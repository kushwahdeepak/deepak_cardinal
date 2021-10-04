import React from 'react'
import { useField } from 'formik'
import styled from 'styled-components'

const Wrapper = styled.div`
    display: flex;
    flex-direction: column;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #000000;
`

const Label = styled.label`
    font-size: 15px;
    line-height: 20px;
    color: #212e75;
    cursor: pointer;
`

const Input = styled.input`
    background: #ffffff;
    border: 2px solid #dadfff;
    box-sizing: border-box;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 2px;
    margin-right: 15px;
`
const ErrorMessage = styled.div`
    font-size: 10px;
    color: red;
    margin-top: 5px;
`

const FormRadioInput = ({ children, ...props }) => {
    const [field, meta] = useField({ ...props, type: 'radio' })

    return (
        <Wrapper>
            <Label>
                <Input type="radio" {...field} {...props} />
                {children}
            </Label>
            {meta.touched && meta.error ? (
                <ErrorMessage>{meta.error}</ErrorMessage>
            ) : null}
        </Wrapper>
    )
}

export default FormRadioInput
