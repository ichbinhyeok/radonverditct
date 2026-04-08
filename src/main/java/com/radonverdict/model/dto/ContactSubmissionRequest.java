package com.radonverdict.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class ContactSubmissionRequest {

    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must be under 100 characters")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    @Size(max = 150, message = "Email must be under 150 characters")
    private String email;

    @NotBlank(message = "Message is required")
    @Size(max = 4000, message = "Message must be under 4000 characters")
    private String message;
}
