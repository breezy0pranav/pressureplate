#include "../include/array.h"

#include "../include/array.h"

int main() {
    Array a({1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f}, {2, 3});
    Array b({6.0f, 5.0f, 4.0f, 3.0f, 2.0f, 1.0f}, {2, 3});

    std::cout << "A: "; a.print();
    std::cout << "B: "; b.print();

    Array c = a.add(b);
    std::cout << "A + B: "; c.print();

    Array d = a.subtract(b);
    std::cout << "A - B: "; d.print();

    return 0;
}
