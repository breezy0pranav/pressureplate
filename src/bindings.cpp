#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "../include/array.h"

namespace py = pybind11;

PYBIND11_MODULE(pressureplate, m) {
    m.doc() = "Pressureplate - A numpy-like library with CPU and GPU support";

    // Enums must be registered BEFORE Array
    py::enum_<Device>(m, "Device")
        .value("CPU", Device::CPU)
        .value("GPU", Device::GPU);

    py::enum_<DType>(m, "DType")
        .value("FLOAT32", DType::FLOAT32)
        .value("FLOAT64", DType::FLOAT64);

    py::class_<Array>(m, "Array")
        .def(py::init<std::vector<float>, std::vector<int>, Device, DType>(),
             py::arg("data"),
             py::arg("shape"),
             py::arg("device") = Device::CPU,
             py::arg("dtype") = DType::FLOAT32)
        .def("add", &Array::add)
        .def("subtract", &Array::subtract)
        .def("matmul", &Array::matmul)
        .def("print", &Array::print)
        .def("size", &Array::size)
        .def("__add__", &Array::add)
        .def("__sub__", &Array::subtract)
        .def("__matmul__", &Array::matmul)
        .def_readwrite("data", &Array::data)
        .def_readwrite("shape", &Array::shape);
}
