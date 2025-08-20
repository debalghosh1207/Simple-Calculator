#include <array> // Added for std::array
#include <cassert>
#include <cstdlib>
#include <iostream>
#include <memory> // Added for std::unique_ptr
#include <sstream>
#include <string>

std::string exec(const std::string &cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd.c_str(), "r"),
                                                pclose);
  if (!pipe) {
    throw std::runtime_error("popen() failed!");
  }
  // Removed setbuffer line as it's unnecessary and causes errors
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    result += buffer.data();
  }
  return result;
}

void trim(std::string &s) { s.erase(s.find_last_not_of(" \n\r\t") + 1); }

int main() {
  // Test addition
  std::string result = exec("./basic-calculator add 2 3");
  trim(result);
  assert(result == "5" && "Addition test failed");

  // Test subtraction
  result = exec("./basic-calculator subtract 5 2");
  trim(result);
  assert(result == "3" && "Subtraction test failed");

  // Test multiplication
  result = exec("./basic-calculator multiply 5 2");
  trim(result);
  assert(result == "10" && "Multiplication test failed");

  // Test division
  result = exec("./basic-calculator divide 5 2");
  trim(result);
  assert(result == "2.5" && "Division test failed");

  result = exec("./basic-calculator divide 5 0");
  trim(result);
  assert(result == "inf" && "Division test failed");

  std::cout << "All tests passed!" << std::endl;
  return 0;
}
