 -- tạo CSDL 
 create database demoquery;
 use demoquery;
 create table Catalogs(
 id int primary key auto_increment,
 name varchar(50) not null,
 status bit default 1 
 );
 create table nhacungcap (
 id int primary key auto_increment,
 name varchar(100),
 phone varchar(11)
 );
 create table Products(
 id int primary key auto_increment,
 name varchar(100) not null,
 price double check (price > 0),
 description text ,
 status bit default 1,
 catalog_id int ,
 mancc int,
 foreign key(catalog_id) references Catalogs(id),
 foreign key(mancc) references nhacungcap(id)
 ) ;
 
 
 -- chèn dữ liệu
 
 insert into Catalogs(name) values
 ("Thời trang"),
 ("Văn Hóa"),
 ("Công Nghệ"),
 ("Ẩm thực"),
 ("Âm Nhạc");
 insert  into nhacungcap(name, phone) values
 ("Song Hồng","0987636453"),
 ("Thịnh Phát","0974365826"),
 ("VinGroup","0888884574"),
 ("Việt Mỹ","0993985746"),
 ("Á Đông","0987347333");
 
 insert into Products(name, price, description, catalog_id, mancc)  values
 ("Vòng tay nữ", 150,"vòng tay cao cấp",1,1),
 ("Áo vest nam", 980,"Áo vest nhập khẩu",1,2),
 ("Bánh giò", 10,"đặc sản miền bắc",4,3),
 ("Bún bò Huế", 5,"đặc sản Huế",4,4),
 ("Sản phẩm 1", 250,"mô tả ",2,5),
 ("Sản phẩm 2", 350,"mô tả ",2,3),
 ("Sản phẩm 3", 150,"mô tả ",3,4),
 ("Sản phẩm 4", 50,"mô tả ",3,5),
 ("Sản phẩm 5",200,"mô tả ",3,2),
 ("Sản phẩm 6", 300,"mô tả ",1,1),
 ("Sản phẩm 7", 400,"mô tả ",1,2),
 ("Sản phẩm 8", 80,"mô tả ",4,4),
 ("Sản phẩm 9", 120,"mô tả ",4,5),
 ("Sản phẩm 10", 175,"mô tả ",2,1),
 ("Sản phẩm 11", 450,"mô tả ",2,2);
 select * from products ;
 
 
 -- Truy vấn dữ liệu đầy đủ (chọn lọc dữ liệu theo điều kiện để biến thành thông tin)
 
 -- cú pháp đầy dủ 
 
 -- SELECT - lấy những cột dữ liệu nào
 -- FROM - lấy từ những bảng bào
 -- WHERE -  lấy theo điều kiện gì
 -- GROUP BY  - dữ liệu sau khi lấy có càn nhóm để xử lí hay không
 -- HAVING - điều kiện của dữ liệu sau khi nhóm(bắt buộc phải có group by)
 -- ORDER BY - sắp xếp theo chiều nào (ASC, DESC)
 -- (LIMIT,OFFSET) -- láy tối đa bnh bản ghi, bắt đàu duyệt dữ liẹu từ vị trí nào
 
 
 select id,name, price from products where price >= 200 order by price desc, name desc ;
 
 -- đếm số lượng sản phẩm của mỗi danh mục 
 -- nhóm các sẩn phẩm có cùng danh mục lại với nhau
 select c.id, c.name , count(p.id) from Products p join Catalogs c on p.catalog_id = c.id group by c.id; 
 
 -- Tính giá tiền trung bình của sản phầm của mỗi nhà chung cấp 
 -- hàm avg()
select ncc.id, ncc.name, AVG(p.price) as giaTrungBinhSP
from nhacungcap ncc  join Products p on ncc.id = p.mancc
group by ncc.id;

-- hiển thị các danh mục có số lượng sản phẩm > 3 
select c.id, c.name , count(p.id) as cou from Products p join Catalogs c on p.catalog_id = c.id 
group by c.id having cou>3;
-- hiển thị những nhà cung cấp có giá bán sản phẩm cao nhất 
-- (ví dụ ncc1 bán sp giá cáo nhất là 1000 $ , ncc2 cx bán sp 
-- có giá cao nhất là 1000$ , các nhà còn lại bán thấp hơn)
-- COUNT(), MIN(), MAX(), SUM(),AVG()

SELECT ncc.id, ncc.name, p.price as highest_price
FROM nhacungcap ncc JOIN Products p ON ncc.id = p.mancc
WHERE p.price = (SELECT MAX(price) FROM products);

select ncc.id ID_NCC, ncc.name NCC_NAME,max(price) from Products p 
join nhacungcap ncc  
on p.mancc = ncc.id
GROUP BY ncc.id having max(price) =  (select max(price) max_price from Products) ;

SELECT ncc.id, ncc.name, MAX(p.price) as highest_price
FROM nhacungcap ncc JOIN Products p ON ncc.id = p.mancc
GROUP BY ncc.id HAVING highest_price = (SELECT MAX(price) FROM Products);

select avg(price), mancc  from products group by mancc;
-- Mệnh đề join : dùng để kết hợp dữ liệu từ 2 hoặc nhiều bảng quan hệ vơs nhau dựa vào cột chung

-- Inner Join 
select * from Products p inner join Catalogs c on p.catalog_id =  c.id;
-- left join : hiển thị toàn bộ bản ghi của bảng bên tay trái mà không cần bảng bên tay phải khớp dữ liệu 
select * from Products p left join Catalogs c on p.catalog_id =  c.id;

-- right join : hiển thị toàn bộ bản ghi của bảng bên tay trái mà không cần bảng bên tay phải khớp dữ liệu 
select * from Products p right join Catalogs c on p.catalog_id =  c.id;

-- full outer join  
select * from Products p left join Catalogs c on p.catalog_id =  c.id
union
select * from Products p right join Catalogs c on p.catalog_id =  c.id;




-- tạo 1 sp ko có danh mụcache index
 insert into Products(name, price, description, catalog_id)  values
 ("Áo sơ mi nam", 450,"áo co giãn",null);
 
 -- join 3 bảng catalogs, products, nhacungcap
 select * from  Products p join Catalogs c on p.catalog_id = c.id join nhacungcap ncc on p.mancc = ncc.id;
 
 