import pressureplate as pl

a = pl.Array([1.0, 2.0, 3.0, 4.0], [2, 2])
b = pl.Array([5.0, 6.0, 7.0, 8.0], [2, 2])

a.print()
b.print()

c = a + b
c.print()

d = a @ b
d.print()
