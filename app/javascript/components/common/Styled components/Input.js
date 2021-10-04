import React from 'react'
import styled from 'styled-components'

const Label = styled.label`
    font-style: normal;
    font-weight: normal;
    font-size: 12px;
    color: #7a8ac2;
    margin-bottom: 8px;
    display: flex;
`

const InputField = styled.input`
    background: #f5f7ff;
    border-radius: 2px;
    border: ${({ isValid }) => (isValid ? 'none' : '1px solid red')};
    outline: none;
    font-style: normal;
    font-weight: 400;
    font-size: 14px;
    color: #4a5489;
    height: 30px;
    padding: 7px 15px;

    &:focus {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 2px;
    }

    &::-webkit-outer-spin-button,
     &::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
`
const Select = styled.input`
    background: #f5f7ff;
    border-radius: 2px;
    border: 1px solid #f5f7ff;
    outline: none;
    font-style: normal;
    font-weight: 400;
    font-size: 14px;
    color: #4a5489;
    height: 30px;
    padding: 5px 15px;

    &:focus {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 2px;
    }
`

const Wrapper = styled.div`
    display: flex;
    flex-direction: column;
    width:${(props)=>props.width?props.width:'unset'};
`
const Textarea = styled.textarea`
    background: #f5f7ff;
    border-radius: 2px;
    color: #4a5489;
    border: none;
    outline: none;
    display: flex;
    width: 97%;
    font-style: normal;
    font-weight: 400;
    font-size: 14px;
    resize: none;
    padding: 12px 15px;
    &:focus {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 2px;
        border: none;
    }
`

function Input(props) {
    const { value, label, name, placeholder, type, onChange, options, isValid=true,maxLength='', width='unset'} = props
    const onKeyDown = props.onKeyDown || null
    const handleKeyPress = (event) => {
        if (onKeyDown != undefined) {
            onkeydown(event)
        }
    }
    return (
        <Wrapper width={width}>
            {label != 'no-label' && <Label>{label}</Label>}
            {type != 'textarea' ? (
                ( (type === 'select' || type === 'select-custom') ? (

                    (type === 'select' ? (
                        <Select 
                        as="select" 
                        name={name || ''} 
                        isValid={isValid} 
                        onChange={(e) => onChange(e)}
                        value={value}
                        >
                        <option>{`Select ${label}`}</option>
                        {options ? options.map((val,key)=>(
                            <option key={key} value={val.key}>{val.value}</option>
                            )) : (<div></div>)}
                    </Select>
                    ) :(
                        <Select 
                        as="select" 
                        name={name || ''} 
                        isValid={isValid} 
                        onChange={(e) => onChange(e)}
                        value={value}
                        width="200px"
                        >
                        <option>{`Select ${label}`}</option>
                        {options ? options.map((val,index)=>(  
                            <option key={index}  data-code={val} value={val}>{val}</option>
                            )) : (<div></div>)}

                      </Select>
                    ))
                    
                ) :(
                    <InputField
                    type={type}
                    value={value || ''}
                    isValid={isValid}
                    onChange={(e) => onChange(e)}
                    onKeyPress={handleKeyPress}
                    placeholder={placeholder || ''}
                    name={name || ''}
                    maxLength={maxLength}
                />
                ))
            ) : (
                <Textarea
                    rows="3"
                    cols="150"
                    type={type}
                    value={value}
                    onChange={(e) => onChange(e)}
                    placeholder={placeholder || ''}
                    name={name || ''}
                    maxLength={maxLength}
                />
            )}
        </Wrapper>
    )
}

export default Input
