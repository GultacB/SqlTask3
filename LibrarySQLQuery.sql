USE LibrarySQL

--1--
DECLARE @minpage INT
SET @minpage=(SELECT MIN(Pages) FROM Books)       

SELECT [Name],Pages
FROM Books
WHERE Pages=@minpage  

--OR-- 
SELECT [Name],Pages
FROM Books
WHERE Pages=(SELECT MIN(Pages) FROM Books)

--2--

SELECT Press.Name
FROM Books
JOIN Press ON Books.Id_Press=Press.Id
GROUP BY Press.Name
HAVING AVG(Pages)>100

--3--

SELECT SUM(Pages) AS TotalPageOfCount, Press.Name
FROM Books 
JOIN Press ON Books.Id_Press=Press.Id
WHERE Press.Name IN ('Бином', 'BHV')
GROUP BY Press.Name

--4--
SELECT FirstName,LastName,DateOut
FROM S_Cards
JOIN Students ON Id_Student=Students.Id
WHERE DateOut BETWEEN '2001/01/01' AND GETDATE()

--5--
SELECT Authors.FirstName,Authors.LastName,Books.Name,Students.FirstName,Students.LastName
FROM Authors
JOIN Books ON Authors.Id=Books.Id_Author
JOIN S_Cards ON Books.Id=S_Cards.Id_Book
JOIN Students ON S_Cards.Id_Student=Students.Id
WHERE Authors.FirstName='Ольга' AND Authors.LastName='Кокорева'

--6--
SELECT Authors.FirstName,Authors.LastName
FROM Books
JOIN Authors ON Authors.Id=Books.Id_Author
GROUP BY  Authors.FirstName,Authors.LastName
HAVING  AVG(Pages)>600

--7--
SELECT Press.Name 
FROM Books
JOIN Press ON Books.Id_Press=Press.Id
WHERE Pages>700
GROUP BY Press.Name

--8--

SELECT Students.FirstName AS StudentFirstName,Students.LastName AS StudentLastName,Books.Name AS BookName
FROM S_Cards
JOIN Books ON S_Cards.Id_Book=Books.Id
JOIN Students ON S_Cards.Id_Student=Students.Id


SELECT Teachers.FirstName AS TeacherFirstName,Teachers.LastName	AS TeacherLastName,	Books.Name  
FROM T_Cards
JOIN Books ON T_Cards.Id_Book=Books.Id
JOIN Teachers ON T_Cards.Id=Teachers.Id


--or--
			   
SELECT Students.FirstName AS StudentFirstName,Students.LastName AS StudentLastName,Teachers.FirstName AS TeacherFirstName,Teachers.LastName	AS TeacherLastName,Books.Name AS BookName
FROM S_Cards
JOIN Books ON S_Cards.Id_Book=Books.Id
JOIN Students ON S_Cards.Id_Student=Students.Id 
JOIN T_Cards ON T_Cards.Id_Book=Books.Id
JOIN Teachers ON T_Cards.Id=Teachers.Id

--9--

SELECT COUNT(Books.Name) AS BooksCount, Books.Name AS BooksName,Authors.FirstName,Authors.LastName
FROM S_Cards
JOIN Books ON S_Cards.Id_Book=Books.Id
JOIN Students ON S_Cards.Id_Student=Students.Id
JOIN Authors ON Authors.Id=Books.Id_Author
GROUP BY Books.Name,Authors.FirstName,Authors.LastName
HAVING COUNT(Books.Name) = (SELECT MAX(BookCount)
                            FROM (SELECT COUNT(Books.Name) AS BookCount                        
                                  FROM S_Cards
                                  JOIN Books ON S_Cards.Id_Book = Books.Id
                                  JOIN Students ON S_Cards.Id_Student = Students.Id
                                  GROUP BY Books.Name) AS BookCounts)

--10--

SELECT COUNT(Books.Name)AS BooksCount,Books.Name as BookName,Authors.FirstName as AutorFirstName,Authors.LastName as AutorLastName
FROM T_Cards
JOIN Teachers ON T_Cards.Id_Teacher=Teachers.Id
JOIN Books ON Books.Id=T_Cards.Id_Book
JOIN Authors ON Books.Id_Author=Authors.Id
GROUP BY Books.Name,Authors.FirstName,Authors.LastName
HAVING COUNT(Books.Name)=(SELECT MAX(FavoriteBook)
                          FROM(SELECT COUNT(Books.Name)AS FavoriteBook
                               FROM T_Cards
                               JOIN Teachers ON T_Cards.Id_Teacher=Teachers.Id
                               JOIN Books ON Books.Id=T_Cards.Id_Book
                               GROUP BY Books.Name) AS BookCounts)


--11--

SELECT COUNT(Id_Themes)AS FavoriteThemeCount,Themes.Name as ThemesName
FROM Books
JOIN Themes ON Books.Id_Themes=Themes.Id
GROUP BY Themes.Name
HAVING COUNT(Id_Themes)=(SELECT MAX(FavoriteTheme) 
                         FROM(SELECT COUNT(Id_Themes)AS FavoriteTheme
                              FROM Books
                              JOIN Themes ON Books.Id_Themes=Themes.Id
                              GROUP BY Themes.Name)AS ThemCount)


--12--


DECLARE @MemberStudentCount INT
SET @MemberStudentCount=(SELECT COUNT(Students.FirstName) AS MemberStudentCount
                         FROM S_Cards
                         JOIN Students ON S_Cards.Id_Student=Students.Id)

DECLARE @MemberTeacherCount INT
SET @MemberTeacherCount=(SELECT COUNT(Teachers.FirstName) AS MemberTeacherCount
                          FROM T_Cards
                          JOIN Teachers ON T_Cards.Id_Teacher=Teachers.Id)

DECLARE @MembersCount TABLE(StudentCount INT,TeacherCount INT)
INSERT INTO @MembersCount Values (@MemberStudentCount,@MemberTeacherCount)

SELECT *
FROM @MembersCount


