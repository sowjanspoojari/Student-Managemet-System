package com.attendance.service;

import com.attendance.model.User;
import com.attendance.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    public User validateLogin(String username, String password) {
        Optional<User> user = userRepository.findByUsernameAndPassword(username, password);
        return user.orElse(null);
    }

    public User registerUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return null; // Username already exists
        }
        return userRepository.save(user);
    }

    public User findByUsername(String username) {
        return userRepository.findByUsername(username).orElse(null);
    }

    @SuppressWarnings("null")
    public User findById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
}
