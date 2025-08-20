#ifndef OPERATIONS_CPP
#define OPERATIONS_CPP

#include "./operations.hpp"

int Operations::add(int first, int second) { return first + second; }
int Operations::subtract(int first, int second) { return first - second; }
int Operations::multiply(int first, int second) { return first * second; }
float Operations::divide(int first, int second) {
  return ((float)first / (float)second);
}

#endif
