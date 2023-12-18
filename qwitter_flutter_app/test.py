import socketio

# Create a Socket.IO client
sio = socketio.Client()

# Define the event handler for the 'connect' event
@sio.event
def connect():
    print('Connected to server')

# Define the event handler for the 'message' event
@sio.event
def message(data):
    print(f"Received message: {data}")

# Define the event handler for the 'disconnect' event
@sio.event
def disconnect():
    print('Disconnected from server')

# Connect to the Socket.IO server
sio.connect('http://back.qwitter.cloudns.org:1982')  # Replace with the actual server URL

try:
    # Send a message to the server
    sio.send('Hello, server!')

    # Wait for a while to receive messages
    sio.sleep(2)

except Exception as e:
    print(f"Error: {e}")

finally:
    # Disconnect from the server
    sio.disconnect()
    print('Disconnected from server')
