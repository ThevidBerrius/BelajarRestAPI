using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using RestAPI.DataAccess;
using RestAPI.Models;

namespace RestAPI.Controllers
{
    public class UserController : ApiController
    {
        private UserDA userDA = new UserDA();

        [HttpGet]
        public HttpResponseMessage GetUsers()
        {
            return Request.CreateResponse(HttpStatusCode.OK, userDA.GetAllUsers());
        }

        [HttpGet]
        public HttpResponseMessage GetUserByUsername(string username)
        {
            var user = userDA.GetUserByUsername(username);
            return user != null
                ? Request.CreateResponse(HttpStatusCode.OK, user)
                : Request.CreateResponse(HttpStatusCode.BadRequest, "User Not Found!");
        }

        [HttpPost]
        public HttpResponseMessage AddUser(UserModel user)
        {
            if (!ModelState.IsValid)
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Data!");

            user.LastModifiedBy = "System";
            user.LastModifiedDate = DateTime.Now;

            userDA.AddUser(user);
            return Request.CreateResponse(HttpStatusCode.OK, user);
        }

        [HttpPut]
        public HttpResponseMessage UpdateUser(UserModel user)
        {
            if (!ModelState.IsValid)
                return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Data");

            user.LastModifiedBy = "System";
            user.LastModifiedDate = DateTime.Now;

            return userDA.UpdateUser(user)
                ? Request.CreateResponse(HttpStatusCode.OK, user)
                : Request.CreateResponse(HttpStatusCode.BadRequest, "User Not Found!");
        }

        [HttpPost]
        public HttpResponseMessage ValidateUser(LoginModel credentials)
        {
            return userDA.ValidateUser(credentials.Username, credentials.Password)
               ? Request.CreateResponse(HttpStatusCode.OK, credentials.Username)
               : Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Credntial!");
        }
    }
}
