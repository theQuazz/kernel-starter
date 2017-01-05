#include <stdint.h>

#define UART0_BASE                 0x101f1000
#define UART_DATA_OFFSET           0x0  // low 8 bits
#define UART_FLAG_OFFSET           0x18 // low 8 bits
#define RXFE_MASK                  0x10 // Receive buffer full
#define TXFF_MASK                  0x20 // Transmit buffer full

int bwputc(char ch) {
  while ((*(volatile uint32_t*)(UART0_BASE + UART_FLAG_OFFSET) & TXFF_MASK));
  *(volatile uint32_t*)(UART0_BASE + UART_DATA_OFFSET) = ch;
  return 0;
}

int bwgetc(void) {
  while ((*(volatile uint32_t*)(UART0_BASE + UART_FLAG_OFFSET) & RXFE_MASK));
  return *(volatile uint32_t*)(UART0_BASE + UART_DATA_OFFSET);
}

int bwputs(char *s) {
  while (*s) {
    bwputc(*s++);
  }
  return 0;
}

int main(void) {
  for (;;) {
    int ch = bwgetc();
    if (ch == 'q') break;
    bwputc(ch);
  }

  bwputs("\nexiting kernel...");

  return 0;
}
