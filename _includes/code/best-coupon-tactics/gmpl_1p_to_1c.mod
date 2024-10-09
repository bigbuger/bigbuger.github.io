set Product;
# 优惠券集合
set Coupon;

# 商品价格
param p{i in Product};

# 优惠券最大可用金额
param c{j in Coupon};

#优惠券减免折扣
param w{j in Coupon};

# x[i][j] 第 i 个商品 使用第 j 张优惠券
var x{i in Product, j in Coupon}, binary;

# 最大化优惠金额
maximize d:
    sum{i in Product, j in Coupon} p[i] * w[j] * x[i,j];

# 每张优惠券不能超过最大可用金额
s.t. cap{j in Coupon}: sum{i in Product} p[i] * x[i, j] <= c[j];

# 一个商品只能用一个优惠券
s.t. only1{i in Product}: sum{j in Coupon} x[i,j] <= 1;

solve;

printf "result start\n";
for {j in Coupon} {
    printf "优惠券 %s, 应用到下列商品:\n", j;
    printf{i in Product: x[i, j] == 1} "%s ", i;
    printf "\n";
}
printf "最大优惠金额: %f\n", d;
printf "result end\n";


end;

