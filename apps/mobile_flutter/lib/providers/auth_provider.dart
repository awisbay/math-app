import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/sources/api_client.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthNotifier(apiClient);
});

final currentUserProvider = Provider<UserProfile?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserProfile? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserProfile? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _apiClient;
  final _secureStorage = const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';

  AuthNotifier(this._apiClient) : super(AuthState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Try to restore token
      final token = await _secureStorage.read(key: _tokenKey);
      
      if (token != null) {
        _apiClient.setAuthToken(token);
        
        // Fetch fresh profile
        final response = await _apiClient.getProfile();
        
        if (response.success && response.data != null) {
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            user: response.data,
          );
        } else {
          // Token invalid, clear it
          await logout();
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final response = await _apiClient.login(email, password);
    
    if (response.success && response.data != null) {
      // For Firebase auth, we'd get a token here
      // For now, we'll use a mock token
      const token = 'mock-token';
      await _secureStorage.write(key: _tokenKey, value: token);
      _apiClient.setAuthToken(token);
      
      // Fetch profile
      final profileResponse = await _apiClient.getProfile();
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: profileResponse.data,
      );
      
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      );
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    String? birthDate,
    int? currentGrade,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final response = await _apiClient.register(
      email: email,
      password: password,
      name: name,
      birthDate: birthDate,
      currentGrade: currentGrade,
    );
    
    if (response.success && response.data != null) {
      const token = 'mock-token';
      await _secureStorage.write(key: _tokenKey, value: token);
      _apiClient.setAuthToken(token);
      
      final profileResponse = await _apiClient.getProfile();
      
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: profileResponse.data,
      );
      
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
    _apiClient.setAuthToken(null);
    state = AuthState();
  }

  Future<void> refreshProfile() async {
    final response = await _apiClient.getProfile();
    
    if (response.success && response.data != null) {
      state = state.copyWith(user: response.data);
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? birthDate,
    int? currentGrade,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final response = await _apiClient.updateProfile(
      name: name,
      birthDate: birthDate,
      currentGrade: currentGrade,
    );
    
    if (response.success && response.data != null) {
      state = state.copyWith(
        isLoading: false,
        user: response.data,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      );
      return false;
    }
  }

  Future<bool> switchGrade(int grade) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final response = await _apiClient.switchGrade(grade);
    
    if (response.success) {
      // Refresh profile to get updated grade
      await refreshProfile();
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
