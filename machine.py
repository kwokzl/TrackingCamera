import socket
import network
import machine

left_motor1 = machine.Pin(12, machine.Pin.OUT)  
left_motor2 = machine.Pin(13, machine.Pin.OUT)  
right_motor1 = machine.Pin(14, machine.Pin.OUT) 
right_motor2 = machine.Pin(15, machine.Pin.OUT)
left_motor1.off()
left_motor2.off()
right_motor1.off()
right_motor2.off()

# 配置接入点模式
def setup_ap(ssid="MicroPython-AP", password="12345678"):
    ap = network.WLAN(network.AP_IF)
    ap.active(True)
    ap.config(essid=ssid, password=password)
    
    while not ap.active():
        pass
    
    print(f"AP 已启动: {ssid}")
    print(f"IP 地址: {ap.ifconfig()[0]}")
    return ap

# 处理客户端请求
def handle_client(client_socket):
    # 接收客户端请求
    request_data = client_socket.recv(1024).decode('utf-8')
    print('接收到请求:')
    print(request_data)
    
    # 解析请求路径
    request_lines = request_data.splitlines()
    if not request_lines:
        client_socket.close()
        return
        
    request_line = request_lines[0]
    method, path, _ = request_line.split(' ', 2)
    
    # 处理请求
    if method == 'GET' and path == '/m1o1':#1zheng
        
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
        left_motor1.on()
        left_motor2.off()
    elif method == 'GET' and path == '/m1o2':#1fan
        left_motor1.off()
        left_motor2.on()
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
    elif method == 'GET' and path == '/m1n':
        left_motor1.off()
        left_motor2.off()
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
    elif method == 'GET' and path == '/m2o1':#2zheng
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
        right_motor1.on()
        right_motor2.off()
    elif method == 'GET' and path == '/m2o2':#2fan
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
        right_motor1.off()
        right_motor2.on()
    elif method == 'GET' and path == '/m2n':
        response = 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n'
        right_motor1.off()
        right_motor2.off()
    
    # 发送响应
    client_socket.sendall(response.encode('utf-8'))
    client_socket.close()

# 启动 HTTP 服务器
def start_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    
    server_address = ('0.0.0.0', 80)
    server_socket.bind(server_address)
    server_socket.listen(1)
    print('HTTP 服务器已启动，等待连接...')
    
    while True:
        client_socket, client_address = server_socket.accept()
        print(f'客户端连接来自: {client_address}')
        handle_client(client_socket)

# 主程序
if __name__ == "__main__":
    ap = setup_ap(ssid="MyMicroPythonAP", password="SecurePass123")
    start_server()
