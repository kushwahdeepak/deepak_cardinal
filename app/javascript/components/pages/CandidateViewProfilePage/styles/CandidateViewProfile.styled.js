import styled from 'styled-components'

export const Wrapper = styled.div`
    padding: 5px;
    width: 100%;
    height: 40rem;
`
export const ImageContainer = styled.div`
    display: flex;
    border-radius: 10px;
    width: 150px;
    height: 150px;
    margin-bottom: 10px;

    > img {
        border-radius: 10px;
        width: 150px;
    }
`
export const Container = styled.div`
    display: flex;
    flex-direction: ${(props) => props.direction};
    flex-wrap: wrap;
    flex: ${(props) => (props.flex ? props.flex : 'unset')};
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
`

export const Row = styled.div`
    display: flex;
    flex-direction: ${(props) => props.direction};
    flex-wrap: wrap;
    width: 100%;
    justify-content: ${(props) => (props.jContent ? props.jContent : 'unset')};
    margin-bottom: 12px;
`
export const Label = styled.label`
    font-style: normal;
    font-weight: normal;
    font-size: 12px;
    color: #7a8ac2;
    margin-bottom: 8px;
    display: flex;
`

export const W4text = styled.span`
    font-style: normal;
    font-weight: 400;
    font-size: ${(props) => props.size};
    color: ${(props) => props.color};
    display: flex;
`

export const W5text = styled(W4text)`
    font-weight: 500;
`
export const W8text = styled(W4text)`
    font-weight: 800;
`
export const InputContainer = styled.div`
    width: ${(props) => props.width};
    margin-bottom: 5px;
    flex-wrap: wrap;
    border: ${({ isValid }) => (!isValid ? 'none' : '1px solid red')};
`

export const Skill = styled.div`
    text-transform: capitalize;
    background: #ebedfa;
    border-radius: 20px;
    color: #768bff;
    padding: 6px 18px;
    margin-right: 5px;
    margin-bottom: 5px;
    display: flex;
    align-items: center;
    transition: all 0.3s ease-in-out;
    > .span{
        display:none;
    }

    > ${W4text} {
        margin: 5px 16px;
    }

    &:hover {
        > span {
            display: flex;
            transition: all 0.3s ease-in-out;
            > svg {
                width: 16px;
                height: 16px;
                color: red;
                transition: all 0.3s ease-in-out;
            }
        }
    }
`

export const ScrollContainer = styled.div`
    display: flex;
    flex-direction: column;
    height: 81%;
    overflow-y: auto;
    margin-bottom: 17px;
`
export const Button = styled.button`
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 20px;
    padding: ${(props) => props.tb} ${(props) => props.lr};
    width: fit-content;
    height: fit-content;
    display: flex;
    align-items: center;
`
export const Button2 = styled(Button)`
    background: #ffffff;
    border: 1px solid #7286f0;
`

export const DatePicker = styled.input`
appearance: none;
position: relative;
-webkit-appearance: none;
color: #4a5489;
font-size: 14px;
border: ${({ isValid }) => (!isValid ? 'none' : '1px solid red')};
outline: none;
height: 30px;
background: #f5f7ff;
padding: 7px 5px;
display: inline-block !important;
visibility: visible !important;

::-webkit-calendar-picker-indicator {
    color: #4a5489;
    border: none;
}
::-webkit-clear-button {
    display: none;
}
::-webkit-inner-spin-button {
    display: none;
}
&:focus {
    background: #ffffff;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 2px;
}
`
export const CheckboxContainer = styled.div`
display: flex;
flex-direction: row;
align-items: center;
display: flex;
margin-left: 5px;
padding-left: 10px;
width: 100%;
justify-content: space-between;
padding-top: 21px;
`
export const  Icon =styled.div`
display: flex;
align-items: center;
justify-content: center;
cursor: pointer;

> svg{
    color:red;
    background: #f5f7ff;
    border-radius: 5px;
    width: 30px;
    height: 30px;
    align-self: flex-end;
}

`