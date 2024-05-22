## file name: restaurantDatabase.py
import mysql.connector
from mysql.connector import Error

class RestaurantDatabase():
    def __init__(self,
                 host="localhost",
                 port="3306",
                 database="restaurant_reservations",
                 user='root',
                 password='Ninetailfox01!'):

        self.host = host
        self.port = port
        self.database = database
        self.user = user
        self.password = password
        self.connection = None
        self.cursor = None
        self.connect()

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                port=self.port,
                database=self.database,
                user=self.user,
                password=self.password)
            
            if self.connection.is_connected():
                print("Successfully connected to the database")
                return
        except Error as e:
            print("Error while connecting to MySQL", e)

    def getAllReservations(self):
        ''' Method to get all reservations from the reservations table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM reservations"
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            return records

    def addReservation(self, customer_id, reservation_time, number_of_guests, special_requests):
        ''' Method to insert a new reservation into the reservations table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "INSERT INTO reservations (customer_id, reservation_time, number_of_guests, special_requests) VALUES (%s, %s, %s, %s)"
            self.cursor.execute(query, (customer_id, reservation_time, number_of_guests, special_requests))
            self.connection.commit()
            print("Reservation added successfully")
            return

    def addCustomer(self, customer_name, contact_info):
        ''' Method to add a new customer to the customers table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "INSERT INTO customers (customer_name, contact_info) VALUES (%s, %s)"
            self.cursor.execute(query, (customer_name, contact_info))
            self.connection.commit()
            print("Customer added successfully")
            return

    def getCustomerPreferences(self, customer_id):
        ''' Method to retrieve dining preferences for a specific customer '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM diningPreferences WHERE customerId = %s"
            self.cursor.execute(query, (customer_id,))
            preferences = self.cursor.fetchall()
            return preferences

    def addSpecialRequest(self, reservation_id, special_request):
        ''' Method to add a special request to an existing reservation '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "UPDATE reservations SET special_requests = %s WHERE reservation_id = %s"
            self.cursor.execute(query, (special_request, reservation_id))
            self.connection.commit()
            print("Special request added successfully")
            return

    def findReservations(self, customer_id):
        ''' Method to find all reservations for a specific customer '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM reservations WHERE customer_id = %s"
            self.cursor.execute(query, (customer_id,))
            reservations = self.cursor.fetchall()
            return reservations

    def deleteReservation(self, reservation_id):
        ''' Method to delete a reservation from the reservations table '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "DELETE FROM reservations WHERE reservation_id = %s"
            self.cursor.execute(query, (reservation_id,))
            self.connection.commit()
            print("Reservation deleted successfully")
            return

    def searchPreferences(self, dietary_restriction):
        ''' Method to search dining preferences based on dietary restrictions '''
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "SELECT * FROM diningPreferences WHERE dietaryRestrictions LIKE %s"
            search_pattern = f"%{dietary_restriction}%"
            self.cursor.execute(query, (search_pattern,))
            preferences = self.cursor.fetchall()
            return preferences

# Add more methods as needed for restaurant operations