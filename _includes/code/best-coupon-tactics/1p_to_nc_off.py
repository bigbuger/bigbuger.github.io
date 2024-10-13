from pyomo.environ import *
import sys

m = AbstractModel()

# 商品集合
m.Product = Set()
# 优惠券集合
m.Coupon = Set()

# 商品价格
m.p = Param(m.Product)

# 优惠券最大可用金额
m.c = Param(m.Coupon)
# 优惠券减免折扣
m.w = Param(m.Coupon)
# 互斥
m.a = Param(m.Coupon, m.Coupon, domain = Binary, default = 0)

#  x[i, j] 第 i 个商品 使用第 j 张优惠券
m.x = Var(m.Product, m.Coupon, domain = Binary)

# 目标: 最小化付款金额
m.d = Objective(
    rule = lambda m: sum(m.p[i] * (prod(1 - m.w[j] * m.x[i, j] for j in m.Coupon)) for i in m.Product),
    sense = minimize
)


# 每张优惠券不能超过最大可用金额
m.cap = Constraint(
    m.Coupon,
    rule = lambda m, j: sum(m.p[i] * m.x[i, j] for i in m.Product) <= m.c[j]
)

m.exclusive = Constraint(
    m.Product, m.Coupon, m.Coupon,
    rule = lambda m, i, g, k: (m.x[i, g] + m.x[i, k]) * m.a[g, k] <= 1
)

data = DataPortal()
filename = sys.argv[1]
data.load(filename=filename)
instance = m.create_instance(data)
#instance.pprint()

opt = SolverFactory('scip')
solution = opt.solve(instance)

for j in instance.Coupon:
    print("优惠券 ", j, "应用到下列商品: ")
    for i in instance.Product:
        if (value(instance.x[i, j]) == 1):
            print(i)

best = value(instance.d)
print("最小付款: ", best)
