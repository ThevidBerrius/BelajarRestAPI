using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using RestAPI.Models;

namespace RestAPI.DataAccess
{
    public class UserDA
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["DBConnect"].ConnectionString;

        public List<UserModel> GetAllUsers()
        {
            List<UserModel> users = new List<UserModel>();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("GetAllUsers", con))
                {
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        while (rdr.Read())
                        {
                            users.Add(new UserModel
                            {
                                UserID = rdr["UserID"] != DBNull.Value ? Convert.ToInt32(rdr["UserID"]) : 0,
                                Username = rdr["Username"] != DBNull.Value ? rdr["Username"].ToString() : string.Empty,
                                FirstName = rdr["FirstName"] != DBNull.Value ? rdr["FirstName"].ToString() : string.Empty,
                                LastName = rdr["LastName"] != DBNull.Value ? rdr["LastName"].ToString() : string.Empty,
                                Active = rdr["Active"] != DBNull.Value && Convert.ToBoolean(rdr["Active"]),
                                LastModifiedBy = rdr["LastModifiedBy"] != DBNull.Value ? rdr["LastModifiedBy"].ToString() : string.Empty,
                                LastModifiedDate = rdr["LastModifiedDate"] != DBNull.Value ? Convert.ToDateTime(rdr["LastModifiedDate"]) : DateTime.MinValue,
                                Password = rdr["Password"] != DBNull.Value ? rdr["Password"].ToString() : string.Empty
                            });
                        }
                    }
                }
            }
            return users;
        }

        public UserModel GetUserByUsername(string username)
        {
            UserModel user = null;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("GetUserByUsername", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Username", username);

                SqlDataReader rdr = cmd.ExecuteReader();

                if (rdr.Read())
                {
                    user = new UserModel
                    {
                        UserID = Convert.ToInt32(rdr["UserID"]),
                        Username = rdr["Username"].ToString(),
                        FirstName = rdr["FirstName"].ToString(),
                        LastName = rdr["LastName"].ToString(),
                        Active = Convert.ToBoolean(rdr["Active"]),
                        LastModifiedBy = rdr["LastModifiedBy"].ToString(),
                        LastModifiedDate = Convert.ToDateTime(rdr["LastModifiedDate"]),
                        Password = rdr["Password"].ToString()
                    };
                }
            }
            return user;
        }


        public void AddUser(UserModel user)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UpdateInsert", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Username", user.Username);
                cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                cmd.Parameters.AddWithValue("@LastName", user.LastName);
                cmd.Parameters.AddWithValue("@Active", user.Active);
                cmd.Parameters.AddWithValue("@LastModifiedBy", user.LastModifiedBy);
                cmd.Parameters.AddWithValue("@LastModifiedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@Password", user.Password);

                cmd.ExecuteNonQuery();
            }
        }

        public bool UpdateUser(UserModel user)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("UpdateInsert", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Username", user.Username);
                cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                cmd.Parameters.AddWithValue("@LastName", user.LastName);
                cmd.Parameters.AddWithValue("@Active", user.Active);
                cmd.Parameters.AddWithValue("@LastModifiedBy", user.LastModifiedBy);
                cmd.Parameters.AddWithValue("@LastModifiedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@Password", string.IsNullOrEmpty(user.Password) ? (object)DBNull.Value : user.Password);

                int rowsAffected = cmd.ExecuteNonQuery();
                return rowsAffected > 0;
            }
        }


        public bool ValidateUser(string username, string password)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("ValidateUser", con);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
    }
}