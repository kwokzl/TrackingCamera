// ��� SystemInit ԭ�ͺͶ���
void SystemInit(void);
void SystemInit(void) {
    // ��ʵ�֣������ļ���Ҫ�������
}

// �����������
typedef unsigned int   uint32_t;
typedef unsigned short uint16_t;
typedef unsigned char  uint8_t;

// �ڴ�ӳ���ַ
#define PERIPH_BASE       ((uint32_t)0x40000000)
#define APB2PERIPH_BASE   (PERIPH_BASE + 0x10000)
#define AHBPERIPH_BASE    (PERIPH_BASE + 0x20000)

// GPIO �Ĵ�������
typedef struct {
    volatile uint32_t CRL;
    volatile uint32_t CRH;
    volatile uint32_t IDR;
    volatile uint32_t ODR;
    volatile uint32_t BSRR;
    volatile uint32_t BRR;
    volatile uint32_t LCKR;
} GPIO_TypeDef;

// RCC �Ĵ�������
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

// USART �Ĵ�������
typedef struct {
    volatile uint32_t SR;
    volatile uint32_t DR;
    volatile uint32_t BRR;
    volatile uint32_t CR1;
    volatile uint32_t CR2;
    volatile uint32_t CR3;
    volatile uint32_t GTPR;
} USART_TypeDef;

// �����ַ����
#define GPIOA_BASE        (APB2PERIPH_BASE + 0x0800)
#define GPIOA             ((GPIO_TypeDef *)GPIOA_BASE)

#define GPIOC_BASE        (APB2PERIPH_BASE + 0x1000)
#define GPIOC             ((GPIO_TypeDef *)GPIOC_BASE)

#define RCC_BASE          (AHBPERIPH_BASE + 0x1000)
#define RCC               ((RCC_TypeDef *)RCC_BASE)

#define USART1_BASE       (APB2PERIPH_BASE + 0x3800)
#define USART1            ((USART_TypeDef *)USART1_BASE)

// �Ĵ���λ����
#define RCC_APB2ENR_IOPAEN    (1 << 2)
#define RCC_APB2ENR_IOPCEN    (1 << 4)
#define RCC_APB2ENR_AFIOEN    (1 << 0)
#define RCC_APB2ENR_USART1EN  (1 << 14)

#define USART_CR1_UE          (1 << 13)
#define USART_CR1_TE          (1 << 3)
#define USART_CR1_RE          (1 << 2)

#define USART_SR_RXNE         (1 << 5)

// ���Ŷ���
#define LEFT_MOTOR_PIN   13
#define RIGHT_MOTOR_PIN  14

// ����ʱ����
static void Delay(uint32_t count) {
    while(count--);
}

int main(void) {
    // 1. ����ʱ��
    RCC->APB2ENR |= RCC_APB2ENR_IOPCEN;   // ����GPIOCʱ��
    RCC->APB2ENR |= RCC_APB2ENR_IOPAEN;   // ����GPIOAʱ��
    RCC->APB2ENR |= RCC_APB2ENR_AFIOEN;   // ����AFIOʱ��
    RCC->APB2ENR |= RCC_APB2ENR_USART1EN; // ����USART1ʱ��
    
    // 2. ���õ���������� (PC13, PC14)
    // �������λ
    GPIOC->CRH &= ~(0xFu << (4*(LEFT_MOTOR_PIN-8)));
    GPIOC->CRH &= ~(0xFu << (4*(RIGHT_MOTOR_PIN-8)));
    // ����Ϊ���ģʽ������ٶ�50MHz (0x3)
    GPIOC->CRH |= (0x3u << (4*(LEFT_MOTOR_PIN-8)));
    GPIOC->CRH |= (0x3u << (4*(RIGHT_MOTOR_PIN-8)));
    
    // 3. ���ô������� (PA9-TX, PA10-RX)
    // �������λ
    GPIOA->CRH &= ~(0xFu << (4*(9-8)));
    GPIOA->CRH &= ~(0xFu << (4*(10-8)));
    // PA9: ����������� (0xB)
    GPIOA->CRH |= (0x3u << (4*(9-8))) | (0x8u << (4*(9-8)));
    // PA10: �������� (0x4)
    GPIOA->CRH |= (0x4u << (4*(10-8)));
    
    // 4. ����USART1 (72MHzʱ�ӣ�9600������)
    USART1->BRR = 72000000 / 9600; // �����ʼĴ���
    USART1->CR1 = USART_CR1_UE | USART_CR1_TE | USART_CR1_RE; // ����USART
    
    // 5. ��ʼ״̬���ر����е��
    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
    
    // 6. ���ԣ����ҵ��������1��
    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN);  // ������
    Delay(1000000);
    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN); // ������
    
    GPIOC->ODR |= (1u << RIGHT_MOTOR_PIN);  // �ҵ����
    Delay(1000000);
    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN); // �ҵ����
    
    while(1) {
        // 7. ����Ƿ������ݽ���
        if(USART1->SR & USART_SR_RXNE) {
            uint8_t command = (uint8_t)(USART1->DR & 0xFF);
            
            // 8. ����ָ����Ƶ��
            switch(command) {
                case 'F': // ǰ��
                    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN) | (1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'L': // ��ת
                    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR |= (1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'R': // ��ת
                    GPIOC->ODR |= (1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
                    break;
                    
                case 'S': // ֹͣ
                default:
                    GPIOC->ODR &= ~(1u << LEFT_MOTOR_PIN);
                    GPIOC->ODR &= ~(1u << RIGHT_MOTOR_PIN);
            }
        }
        
        // 9. ����ʱ
        Delay(100000);
    }
}
