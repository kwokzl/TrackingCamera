// 添加 SystemInit 原型和定义
void SystemInit(void);
void SystemInit(void) {
    // 空实现，启动文件需要这个函数
}

// 定义基本类型
typedef unsigned int   uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char  uint8_t;

// 内存映射地址
#define PERIPH_BASE       ((uint32_t)0x40000000)
#define APB2PERIPH_BASE   (PERIPH_BASE + 0x10000)
#define AHBPERIPH_BASE    (PERIPH_BASE + 0x20000)

// GPIO 寄存器定义
typedef struct {
    volatile uint32_t CRL;
    volatile uint32_t CRH;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
    volatile uint32_t BSRR;
    volatile uint32_t BRR;
    volatile uint32_t LCKR;
} GPIO_TypeDef;

// RCC 寄存器定义
typedef struct {
    volatile uint32_t CR;
    volatile uint32_t CFGR;
    volatile uint32_t CIR;
    volatile uint32_t APB2RSTR;
    volatile uint32_t APB1RSTR;
    volatile uint32_t AHBENR;
    volatile uint32_t APB2ENR;
    volatile uint32_t APB1ENR;
    volatile uint32_t BDCR;
    volatile uint32_t CSR;
} RCC_TypeDef;

// USART 寄存器定义
typedef struct {
    volatile uint32_t SR;
    volatile uint32_t DR;
    volatile uint32_t BRR;
    volatile uint32_t CR1;
    volatile uint32_t CR2;
    volatile uint32_t CR3;
    volatile uint32_t GTPR;
} USART_TypeDef;

// 外设地址定义
#define GPIOA_BASE        (APB2PERIPH_BASE + 0x0800)
#define GPIOA             ((GPIO_TypeDef *)GPIOA_BASE)

#define GPIOC_BASE        (APB2PERIPH_BASE + 0x1000)
#define GPIOC             ((GPIO_TypeDef *)GPIOC_BASE)

#define RCC_BASE          (AHBPERIPH_BASE + 0x1000)
#define RCC               ((RCC_TypeDef *)RCC_BASE)

#define USART1_BASE       (APB2PERIPH_BASE + 0x3800)
#define USART1            ((USART_TypeDef *)USART1_BASE)

// 寄存器位定义
#define RCC_APB2ENR_IOPAEN    (1 << 2)
#define RCC_APB2ENR_IOPCEN    (1 << 4)
#define RCC_APB2ENR_AFIOEN    (1 << 0)
#define RCC_APB2ENR_USART1EN  (1 << 14)

#define USART_CR1_UE          (1 << 13)
#define USART_CR1_TE          (1 << 3)
#define USART_CR1_RE          (1 << 2)

#define USART_SR_RXNE         (1 << 5)

// 引脚定义
#define LEFT_MOTOR_PIN   13
#define RIGHT_MOTOR_PIN  14

// 简单延时函数
static void Delay(uint32_t count) {
    while(count--);
}

int main(void) {
    // 1. 启用时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;   // 启用GPIOC时钟
    RCC->APB2ENR |= RCC_APB2ENR_IOPAEN;   // 启用GPIOA时钟
    RCC->APB2ENR |= RCC_APB2ENR_AFIOEN;   // 启用AFIO时钟
    RCC->APB2ENR |= RCC_APB2ENR_USART1EN; // 启用USART1时钟
    
    // 2. 配置电机控制引脚 (PC13, PC14)
    // 清除配置位
    GPIOC->CRH &= ~(0xFu << (4*(LEFT_MOTOR_PIN-8)));
    GPIOC->CRH &= ~(0xFu << (4*(RIGHT_MOTOR_PIN-8)));
    // 配置为输出模式，最大速度50MHz (0x3)
    GPIOC->CRH |= (0x3u << (4*(LEFT_MOTOR_PIN-8)));
    GPIOC->CRH |= (0x3u << (4*(RIGHT_MOTOR_PIN-8)));
    
    // 3. 配置串口引脚 (PA9-TX, PA10-RX)
    // 清除配置位
    GPIOA->CRH &= ~(0xFu << (4*(9-8)));
    GPIOA->CRH &= ~(0xFu << (4*(10-8)));
    // PA9: 复用推挽输出 (0xB)
    GPIOA->CRH |= (0x3u << (4*(9-8))) | (0x8u << (4*(9-8)));
    // PA10: 浮空输入 (0x4)
    GPIOA->CRH |= (0x4u << (4*(10-8)));
    
    // 4. 配置USART1 (72MHz时钟，9600波特率)
    USART1->BRR = 72000000 / 9600; // 波特率寄存器
    USART1->CR1 = USART_CR1_UE | USART_CR1_TE | USART_CR1_RE; // 启用USART
    
    // 5. 初始状态：关闭所有电机
    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
    
    // 6. 测试：左右电机各运行1秒
    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN);  // 左电机开
    Delay(1000000);
    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN); // 左电机关
    
    GPIOC->ODR |= (1u << RIGHT_MOTOR_PIN);  // 右电机开
    Delay(1000000);
    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN); // 右电机关
    
    while(1) {
        // 7. 检查是否有数据接收
        if(USART1->SR & USART_SR_RXNE) {
            uint8_t command = (uint8_t)(USART1->DR & 0xFF);
            
            // 8. 根据指令控制电机
            switch(command) {
                case 'F': // 前进
                    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN) | (1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'L': // 左转
                    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR |= (1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'R': // 右转
                    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'S': // 停止
                default:
                    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
            }
        }
        
        // 9. 简单延时
        Delay(100000);
    }
}
