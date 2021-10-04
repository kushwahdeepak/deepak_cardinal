import * as Yup from 'yup'


export const passwordSchema = {
    password: Yup.string()
        .required('New Password is required')
        .matches(
            /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,25}$/,
            "Password between 8 and 25 characters must contain at least one lowercase letter, one uppercase letter, one numeric digit, and one special character"
        ),
    confirmPassword: Yup.string().test(
        'passwords-match',
        'Passwords must match',
        function (value) {
            return this.parent.password === value
        }
    ),
}