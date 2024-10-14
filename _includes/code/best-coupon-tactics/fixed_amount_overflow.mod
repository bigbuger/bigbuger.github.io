# -*- mode: gmpl;-*-
# 多满减优惠券，每一个商品只能应用一个券
# 以订单维度计算应付金额最小化
set Product;
set Coupon;

# 加入 zero 券
set cz := {"zero"} union Coupon;

param p{Product}; # 商品价格

param l{cz} default 0;                     # 优惠券下限
param h{j in cz}, >= l[j], default 0;      # 优惠券上限
param w{j in cz}, >= 0, <= h[j] default 0; # 优惠金额

var x{Product, cz} binary;
var y{cz} binary;
var z{cz} binary;

minimize t:
    sum{j in cz} z[j];

s.t. y_min{j in cz, i in Product}: y[j] >= x[i, j];
s.t. y_max{j in cz}: y[j] <= sum{i in Product} x[i, j];

# 每个商品必须属于某个订单
s.t. only1{i in Product}: sum{j in cz} x[i,j] = 1;

# 不能超优惠券上限
s.t. cap_height{j in cz}:
    sum{i in Product}p[i] * x[i, j] <= h[j];

# 达到优惠券下限 y[j] 才 =1
s.t. cap_low{j in cz}:
    l[j] * (1 - y[j]) >= l[j] - sum{i in Product} p[i] * x[i, j];

# z 关联应付金额
s.t. z_not_negative{j in cz}:
    z[j] >= 0;
    
s.t. pay_amount{j in cz}:
    z[j] >= (sum{i in Product} x[i,j] * p[i]) - w[j] * y[j];

solve;

printf "result start\n";
for {j in cz} {
    printf "优惠券 %s, 应用到下列商品:\n", j;
   
    printf{i in Product: x[i, j] == 1} "%s ", i;
    
    printf "\n";
}
printf "最小应付金额: %f\n", t;
printf "result end\n";


data;
set Product := p1 p2 p3;
set Coupon := c1 c2;

# 商品价格
param p :=
    p1 4
    p2 2
    p3 1 ;

# 优惠券 门槛  最高  扣减金额
param : l     h    w :=
    c1  4     10    8
    c2  7     10    6
     ;

end;
