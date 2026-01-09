import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  
  User? _firebaseUser;
  UserModel? _userData;
  bool _isLoading = false;
  String? _errorMessage;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _firebaseUser = firebaseUser;
    
    if (firebaseUser != null) {
      _userData = await _firestoreService.getUser(firebaseUser.uid);
    } else {
      _userData = null;
    }
    
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        _userData = await _firestoreService.getUser(credential.user!.uid);
        
        // Check if user is active
        if (_userData?.status != 'aktif') {
          await signOut();
          _errorMessage = 'Akun Anda tidak aktif. Hubungi admin.';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Log activity
        await _firestoreService.logActivity(
          userId: credential.user!.uid,
          action: 'LOGIN',
          description: 'User login',
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          _errorMessage = 'Password salah';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid';
          break;
        case 'user-disabled':
          _errorMessage = 'Akun dinonaktifkan';
          break;
        default:
          _errorMessage = 'Login gagal: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? noHp,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Check if this is the first user - auto set as super admin
        final isFirstUser = await _firestoreService.isFirstUser();
        final userRole = isFirstUser ? 'admin' : role;
        
        final user = UserModel(
          id: credential.user!.uid,
          email: email,
          nama: nama,
          role: userRole,
          noHp: noHp,
          status: 'aktif',
          createdAt: DateTime.now(),
        );

        await _firestoreService.createUser(credential.user!.uid, user);
        _userData = user;

        // Log activity
        await _firestoreService.logActivity(
          userId: credential.user!.uid,
          action: 'REGISTER',
          description: isFirstUser 
              ? 'First user registered as super admin' 
              : 'User registered',
        );

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'email-already-in-use':
          _errorMessage = 'Email sudah terdaftar';
          break;
        case 'weak-password':
          _errorMessage = 'Password terlalu lemah';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid';
          break;
        default:
          _errorMessage = 'Registrasi gagal: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      if (_firebaseUser != null) {
        await _firestoreService.logActivity(
          userId: _firebaseUser!.uid,
          action: 'LOGOUT',
          description: 'User logout',
        );
      }
      
      await _auth.signOut();
      _userData = null;
      _firebaseUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout gagal: $e';
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'Email tidak terdaftar';
          break;
        case 'invalid-email':
          _errorMessage = 'Format email tidak valid';
          break;
        default:
          _errorMessage = 'Reset password gagal: ${e.message}';
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      if (_firebaseUser == null) return;
      
      await _firestoreService.updateUser(_firebaseUser!.uid, data);
      _userData = await _firestoreService.getUser(_firebaseUser!.uid);
      
      await _firestoreService.logActivity(
        userId: _firebaseUser!.uid,
        action: 'UPDATE_PROFILE',
        description: 'User updated profile',
      );
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Update profil gagal: $e';
      notifyListeners();
    }
  }

  bool hasRole(String role) {
    return _userData?.role == role;
  }

  bool hasAnyRole(List<String> roles) {
    if (_userData == null) return false;
    return roles.contains(_userData!.role);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
