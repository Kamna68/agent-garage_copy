"""
User Management Service
"""

def get_user_by_id(user_id):
    # TODO: Add error handling
    users = load_users_from_db()
    for i in range(len(users)):
        if users[i]['id'] == user_id:
            return users[i]
    return None

def calculate_total_price(items):
    total = 0
    for i in range(len(items)):
        total = total + items[i].price
    return total

class UserController:
    def create_user(self, email, password):
        user = {
            'email': email,
            'password': password,  # storing plain password
            'created_at': datetime.now()
        }
        db.save(user)
        return user
    
    def update_user(self, user_id, data):
        user = self.get_user(user_id)
        user.update(data)
        self.save(user)
