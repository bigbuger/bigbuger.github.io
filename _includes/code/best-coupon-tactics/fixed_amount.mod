set Product;
set Coupon;


param p{Product}; # 商品价格

param l{Coupon};               # 优惠券下限
param h{j in Coupon}, >= l[j]; # 优惠券上限
param w{Coupon}, >= 0;         # 优惠金额

var x{Product, Coupon} binary;
var y{Coupon} binary;

maximize t:
    sum{j in Coupon} w[j] * y[j];

s.t. y_min{j in Coupon, i in Product}: y[j] >= x[i, j];
s.t. y_max{j in Coupon}: y[j] <= sum{i in Product} x[i, j];

# 一个商品只能用一个优惠券
s.t. only1{i in Product}: sum{j in Coupon} x[i,j] <= 1;

# 不能超优惠券上限
s.t. cap_height{j in Coupon}:
    sum{i in Product}p[i] * x[i, j] <= h[j];

# 达到优惠券下限 y[j] 才 =1
s.t. cap_low{j in Coupon}:
    l[j] * (1 - y[j]) >= l[j] - sum{i in Product} p[i] * x[i, j];


solve;

printf "result start\n";
for {j in Coupon} {
    printf "优惠券 %s, 应用到下列商品:\n", j;
   
    printf{i in Product: x[i, j] == 1} "%s ", i;
    
    printf "\n";
}
printf "最大优惠金额: %f\n", t;
printf "result end\n";


end;

