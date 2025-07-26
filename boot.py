import machine
import time
import uos
import urandom

# ===== 电机控制类 =====
class SimpleMotorController:
    def __init__(self):
        # 配置GPIO引脚直接控制电机
        self.left_motor = machine.Pin(12, machine.Pin.OUT)  # 左电机控制
        self.right_motor = machine.Pin(13, machine.Pin.OUT)  # 右电机控制
        
        # 初始状态：电机停止
        self.stop_all()
        
        # 上电自检
        self.startup_test()
    
    def startup_test(self):
        """上电自检：分别测试两个电机"""
        print("执行上电自检...")
        
        # 测试左电机
        print(" - 左电机转动1秒")
        self.left_motor.on()
        time.sleep(1)
        self.left_motor.off()
        time.sleep(0.5)
        
        # 测试右电机
        print(" - 右电机转动1秒")
        self.right_motor.on()
        time.sleep(1)
        self.right_motor.off()
        time.sleep(0.5)
        
        # 测试同时转动
        print(" - 双电机转动1秒")
        self.left_motor.on()
        self.right_motor.on()
        time.sleep(1)
        self.stop_all()
        
        print("自检完成\n")
    
    def move_forward(self):
        """前进：两个电机同时转动"""
        self.left_motor.on()
        self.right_motor.on()
    
    def move_backward(self):
        """后退：需要硬件支持反转，否则无法实现"""
        # 此方案无法直接后退，需要额外电路
        self.stop_all()
    
    def turn_left(self):
        """左转：右电机转动，左电机停止"""
        self.left_motor.off()
        self.right_motor.on()
    
    def turn_right(self):
        """右转：左电机转动，右电机停止"""
        self.left_motor.on()
        self.right_motor.off()
    
    def stop_all(self):
        """停止：两个电机都停止"""
        self.left_motor.off()
        self.right_motor.off()
    
    def pivot_left(self):
        """原地左转：需要额外硬件支持"""
        # 此方案无法实现原地转向
        self.turn_left()
    
    def pivot_right(self):
        """原地右转：需要额外硬件支持"""
        self.turn_right()

# ===== 人体跟随逻辑 =====
class HumanFollower:
    def __init__(self):
        self.motors = SimpleMotorController()
        print("人体跟随系统初始化完成")
        print("等待指令...")
        print("使用简单电机控制模式")
        print("注: 此方案无法实现后退和原地转向")
    
    def follow_human(self, x_pos, speed):
        """根据人体位置和速度控制电机"""
        # 简化跟随逻辑
        if abs(x_pos) > 30:  # 需要转向
            if x_pos > 0:
                self.motors.turn_right()
                return "右转"
            else:
                self.motors.turn_left()
                return "左转"
        elif speed > 20:     # 人体前进
            self.motors.move_forward()
            return "前进"
        else:               # 停止
            self.motors.stop_all()
            return "停止"

# ===== 主程序 =====
def main():
    print("启动极简人体跟随系统")
    print("=" * 40)
    
    follower = HumanFollower()
    
    # 模拟人体数据
    x_pos = 0
    speed = 0
    
    # 主循环
    try:
        while True:
            # 生成随机模拟数据
            x_pos += urandom.randint(-15, 15)
            speed += urandom.randint(-10, 10)
            
            # 限制数据范围
            x_pos = max(-100, min(100, x_pos))
            speed = max(-100, min(100, speed))
            
            # 执行跟随动作
            action = follower.follow_human(x_pos, speed)
            
            # 显示状态信息
            print(f"状态: {action:6} | X位置: {x_pos:4d} | 速度: {speed:4d}")
            
            time.sleep(0.3)  # 控制循环频率
    
    except KeyboardInterrupt:
        follower.motors.stop_all()
        print("\n系统已停止")

if __name__ == "__main__":
    main()