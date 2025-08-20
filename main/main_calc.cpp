#include <cstdlib>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>

#include "./calculator/calculator.hpp"

int main(int argc, char *argv[]) {
  // Check if exactly 4 arguments are provided (program name + 3 args)
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0]
              << " <add|subtract|multiply|divide> <num1> <num2>" << std::endl;
    return 1;
  }

  std::string operation = argv[1];
  int num1 = std::atoi(argv[2]);
  int num2 = std::atoi(argv[3]);

  float result = Calculator::evaluate(operation, num1, num2);

  std::cout << result << std::endl;

  return (0);
}
