#include <stdio.h>
#include <unistd.h>

int main() {
    int pid = fork();
    
    if (pid == 0) {
        printf("Сообщение из дочернего процесса\nРодительский PID: %d\nДочерний PID: %d\n", getppid(), getpid());
    }
    sleep(3);
    return 0;
}
