USE [master]
GO
/****** Object:  Database [UserManagement]    Script Date: 11/02/2025 13:35:16 ******/
CREATE DATABASE [UserManagement]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'UserManagement', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\UserManagement.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'UserManagement_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\UserManagement_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [UserManagement] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [UserManagement].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [UserManagement] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [UserManagement] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [UserManagement] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [UserManagement] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [UserManagement] SET ARITHABORT OFF 
GO
ALTER DATABASE [UserManagement] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [UserManagement] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [UserManagement] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [UserManagement] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [UserManagement] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [UserManagement] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [UserManagement] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [UserManagement] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [UserManagement] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [UserManagement] SET  ENABLE_BROKER 
GO
ALTER DATABASE [UserManagement] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [UserManagement] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [UserManagement] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [UserManagement] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [UserManagement] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [UserManagement] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [UserManagement] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [UserManagement] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [UserManagement] SET  MULTI_USER 
GO
ALTER DATABASE [UserManagement] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [UserManagement] SET DB_CHAINING OFF 
GO
ALTER DATABASE [UserManagement] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [UserManagement] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [UserManagement] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [UserManagement] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [UserManagement] SET QUERY_STORE = ON
GO
ALTER DATABASE [UserManagement] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [UserManagement]
GO
/****** Object:  Table [dbo].[User]    Script Date: 11/02/2025 13:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Active] [bit] NOT NULL,
	[LastModifiedBy] [nvarchar](50) NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 11/02/2025 13:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllUsers]  
AS  
BEGIN  
    SET NOCOUNT ON;  
    SELECT 
        UserID, 
        Username, 
        FirstName, 
        LastName, 
        Active, 
        LastModifiedBy, 
        LastModifiedDate, 
        Password
    FROM [User];  
END;
GO
/****** Object:  StoredProcedure [dbo].[GetUserByUsername]    Script Date: 11/02/2025 13:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserByUsername]  
    @Username NVARCHAR(50)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT UserID, Username, FirstName, LastName, Active, LastModifiedBy, LastModifiedDate, Password  
    FROM [User]  
    WHERE Username = @Username;  
END;  
GO
/****** Object:  StoredProcedure [dbo].[UpdateInsert]    Script Date: 11/02/2025 13:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateInsert]  
    @Username NVARCHAR(50),  
    @FirstName NVARCHAR(100),  
    @LastName NVARCHAR(100),  
    @Active BIT,  
    @LastModifiedBy NVARCHAR(50),  
    @LastModifiedDate DATETIME,  
    @Password NVARCHAR(100) = NULL  
AS  
BEGIN  
    IF EXISTS (SELECT 1 FROM [User] WHERE Username = @Username)  
    BEGIN  
        UPDATE [User]  
        SET FirstName = @FirstName, 
            LastName = @LastName, 
            Active = @Active,   
            LastModifiedBy = @LastModifiedBy, 
            LastModifiedDate = @LastModifiedDate,  
            Password = COALESCE(@Password, Password)  
        WHERE Username = @Username;  
    END  
    ELSE  
    BEGIN  
        INSERT INTO [User] (Username, FirstName, LastName, Active, LastModifiedBy, LastModifiedDate, Password)  
        VALUES (@Username, @FirstName, @LastName, @Active, @LastModifiedBy, @LastModifiedDate, @Password);  
    END  
END;
GO
/****** Object:  StoredProcedure [dbo].[ValidateUser]    Script Date: 11/02/2025 13:35:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ValidateUser]
    @Username NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT COUNT(*) 
    FROM [User] 
    WHERE Username = @Username AND Password = @Password;
END;
GO
USE [master]
GO
ALTER DATABASE [UserManagement] SET  READ_WRITE 
GO
