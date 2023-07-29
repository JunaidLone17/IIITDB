#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure to represent each line
struct Line {
    char* text;
    struct Line* next;
};

// Function to add a line to the linked list
void addLine(struct Line** tail, char* text) {
    struct Line* newLine = (struct Line*)malloc(sizeof(struct Line));
    newLine->text = strdup(text);
    newLine->next = NULL;

    if (*tail != NULL) {
        (*tail)->next = newLine;
    }

    *tail = newLine;
}

void printTailLines(struct Line* head, int n) {
    int lineCount = 0;
    struct Line* current = head;

    // Count the number of lines in the linked list
    while (current != NULL) {
        lineCount++;
        current = current->next;
    }

    // Adjust 'n' to be the minimum of lineCount and the requested number of lines 'n'
    n = (n < lineCount) ? n : lineCount;

    // Traverse the linked list and print the last 'n' lines
    current = head;
    for (int i = 0; i < lineCount - n; i++) {
        current = current->next;
    }

    while (current != NULL) {
        printf("%s", current->text);
        current = current->next;
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    if (n <= 0) {
        printf("Invalid value of 'n'. It must be a positive integer.\n");
        return 1;
    }

    // Initialize the linked list
    struct Line* head = NULL;
    struct Line* tail = NULL;

    char buffer[256]; // Assumes each line is at most 255 characters long

    // Read input lines and update the linked list
    while (fgets(buffer, sizeof(buffer), stdin) != NULL) {
        addLine(&tail, buffer);
        if (head == NULL) {
            head = tail;
        }
    }

  	 printf("%s","\n");
  	 printf("The Last %d lines are:",n);
  	 printf("%s","\n");
    printTailLines(head, n);



    return 0;
}

