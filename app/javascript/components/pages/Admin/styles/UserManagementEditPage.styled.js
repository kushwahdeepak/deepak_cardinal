import styled from 'styled-components'
import { Form } from 'formik'

export const H1 = styled.h1`
    font-size: 30px;
    line-height: 41px;
    text-align: center;
    color: #393f60;
    margin-bottom: 30px;
`

export const P = styled.p`
    font-weight: normal;
    font-size: 20px;
    line-height: 27px;
    text-align: center;
    color: #1d2447;
    margin-bottom: 15px;
`

export const StyledForm = styled(Form)`
    background: #ffffff;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    border-radius: 20px;
    width: 100%;
    padding: 40px 50px;
`
export const A = styled.a`
    font-weight: 500;
    font-size: 16px;
    line-height: 22px;
    text-align: right;
    color: #8091e7;
    cursor: pointer;
`
export const Label = styled.label`
        color: #3a5182;
        cursor: pointer;
        margin-bottom: 4px;
    `