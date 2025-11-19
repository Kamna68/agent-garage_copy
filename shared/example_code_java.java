package com.example.service;

import java.util.List;
import java.util.ArrayList;

public class UserService {
    
    private List<User> users = new ArrayList<>();
    
    public User getUserById(String id) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(id)) {
                return users.get(i);
            }
        }
        return null;
    }
    
    public double calculateTotalPrice(List<Item> items) {
        double total = 0;
        for (int i = 0; i < items.size(); i++) {
            total = total + items.get(i).getPrice();
        }
        return total;
    }
    
    public void createUser(String email, String password) {
        User user = new User();
        user.setEmail(email);
        user.setPassword(password); // storing plain password
        users.add(user);
    }
    
    public String generateToken() {
        return String.valueOf(Math.random());
    }
}
