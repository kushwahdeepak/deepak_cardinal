import React from 'react'
import { useField } from 'formik'
import styled from 'styled-components'

const Wrapper = styled.div.attrs((props) => ({
        width: props.width || '400px',
    }))`
    display: inline-flex;
    flex-direction: column;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #000000;
    margin-bottom: 20px;
    width: ${(props) => props.width};
`

const Label = styled.label`
    color: #3a5182;
    cursor: pointer;
`

const Input = styled.select.attrs((props) => ({
    width: props.width || '400px',
}))`
    background: #f5f7ff;
    border-color: #f5f7ff;
    border-radius: 2px;
    width: ${(props) => props.width};
    border-style: solid;
    padding: 10px 17px;

    &:focus {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 2px;
        outline: 0;
    }
`

const ErrorMessage = styled.div`
    font-size: 10px;
    color: red;
    margin-top: 5px;
    max-width: ${(props) => props.width || 400}px;
`

const Select = ({ label, ...props }) => {
    const [field, meta] = useField(props)

    return (
        <Wrapper width={props.width}>
            <Label htmlFor={props.id || props.name} style={props.style}>
                {label}
            </Label>
            <Input {...field} {...props} />
            {meta.touched && meta.error ? (
                <ErrorMessage style={props.style} width={props.width}>
                    {meta.error}
                </ErrorMessage>
            ) : null}
        </Wrapper>
    )
}

export default Select
