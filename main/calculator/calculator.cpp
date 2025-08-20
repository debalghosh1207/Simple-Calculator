#ifndef CALCULATOR_CPP
#define CALCULATOR_CPP

#include "./calculator.hpp"
#include "./operations/operations.hpp"

int add(int first, int second) { return Operations::add(first, second); }
int subtract(int first, int second) {
  return Operations::subtract(first, second);
}
int multiply(int first, int second) {
  return Operations::multiply(first, second);
}
float divide(int first, int second) {
  return Operations::divide(first, second);
}

float Calculator::evaluate(String operation, int first, int second) {
  if (operation == "add")
    return add(first, second);
  if (operation == "subtract")
    return subtract(first, second);
  if (operation == "multiply")
    return multiply(first, second);
  if (operation == "divide")
    return divide(first, second);

  return 0;
}

#endif
