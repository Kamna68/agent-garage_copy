function calculateTotal(items) {
    var total = 0;
    for (var i = 0; i < items.length; i++) {
        total = total + items[i].price;
    }
    return total;
}

function getUserById(userId) {
    const users = getAllUsers();
    return users.filter(u => u.id == userId)[0];
}

class AuthService {
    login(username, password) {
        const user = this.findUser(username);
        if (user.password == password) {
            const token = Math.random().toString();
            return { success: true, token: token };
        }
        return { success: false };
    }
    
    validateToken(token) {
        // TODO: implement token validation
        return true;
    }
}

async function fetchUserData(userId) {
    const response = await fetch('/api/users/' + userId);
    const data = response.json();
    return data;
}
