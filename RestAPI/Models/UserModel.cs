using System;
using System.ComponentModel.DataAnnotations;

namespace RestAPI.Models
{
    public class UserModel
    {
        public int UserID { get; set; }

        [Required]
        [StringLength(50)]
        public string Username { get; set; }

        [Required]
        [StringLength(50)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(50)]
        public string LastName { get; set; }

        public bool Active { get; set; }

        [StringLength(50)]
        public string LastModifiedBy { get; set; }

        public DateTime LastModifiedDate { get; set; }

        [Required]
        [StringLength(255)]
        public string Password { get; set; }
    }
}