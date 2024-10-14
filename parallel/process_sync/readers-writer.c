#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

sem_t mutex; // mutex for reader to access mutex for reac_count
sem_t rw_mutex; // for reader and writer exclusively lock
int read_count = 0;

void readers(void* arg) {
    do {    
        // first reader hold the mutex, to protect the read count. other readers must wait here
        sem_wait(&mutex);  // must using & to modify, even mutex is a global var. otherwise don't change val of mutex
        read_count++;
        if (read_count == 1) {
            sem_wait(&rw_mutex);
        }
        // if wait, first reader release the mutex, and all readers can enter. so we must control the release mutex 
        // if we release the mutex wait before (post(mutex)) before read_count = 1, 
        // then other readers will go to writer critical section directly
        sem_post(&mutex);

        // execute read op (critical section)
        printf("Reader %d  is reading. \n", *(int*)arg);
        sleep(1); // mimic reading

        sem_wait(&mutex);
        read_count--;
        
        if (read_count == 0) {
            sem_post(&rw_mutex);
        }
        sem_post(&mutex);  // this after the rw_mutex

        sleep(1); // mimic waiting time before next read

    } while (1);
}

void writer(void* arg) {
    do {
        sem_wait(&rw_mutex);

        // execute writing
        printf("writer %d is writing.\n", *(int*)arg);
        sleep(1);

        sem_post(&rw_mutex);
        sleep(1);
    } while (1);
}

int main() {
    pthread_t read_thread[3], write_thread[2];

    int reader_ids[3] = {1,2,3};
    int writer_ids[2] = {1,2};

    // initialize semaphore
    sem_init(&rw_mutex, 0, 1);  // rw_mutex start semaphor is 1. maximum 1 semaphore?
    sem_init(&mutex, 0, 1);

    // create reader thread
    for (int i = 0; i < 3; i++) {
        // ith thread in thread array, using reader func and arg is reader_ids[i]
        // 这是一个指向 pthread_attr_t 结构的指针，用于设置线程的属性，例如是否为分离线程、线程栈大小等。
        pthread_create(&read_thread[i], NULL, readers, &reader_ids[i]);
    }

    for (int i = 0; i < 2; i++) {
        pthread_create(&write_thread[i], NULL, writer, &writer_ids[i]);
    }

    // waiting for all process execute
    for (int i = 0; i < 3; i++) {
        // NULL接收reader返回的exit状态。如果不关心，设为NULL
        pthread_join(read_thread[i], NULL);
    }

    for (int i = 0; i < 2; i++) {
        pthread_join(write_thread[i], NULL);
    }

    // detroy all semaphore
    sem_destroy(&rw_mutex);
    sem_destroy(&mutex);

    return 0;
}

// will keep read and write until interrupt
/** gcc readers-writer.c -o readers-writer -pthread
 * Reader 1  is reading. 
Reader 3  is reading. 
Reader 2  is reading. 
writer 2 is writing.
writer 1 is writing.
Reader 3  is reading. 
Reader 1  is reading. 
Reader 2  is reading. 
writer 2 is writing.
writer 1 is writing.
 */




