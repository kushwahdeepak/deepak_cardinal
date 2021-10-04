import styled from 'styled-components'
import { Popover, Dropdown } from 'react-bootstrap'

export const CustomDropdown = styled(Dropdown)`
    & button.dropdown-toggle {
        background: linear-gradient(101.57deg, #5873ff -6.28%, #92a3ff 103.19%);
        border-radius: 10px;
        min-width: 200px;
        color: #fff;
    }

    & div.dropdown-menu {
        background: #ffffff;
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        padding: 0;
        width: 100%;
        & a {
            padding: 10px 20px;
            border-radius: 10px;
        }
    }
`

export const Header = styled.div`
    background: #f9f9ff;
    border: 1px solid #e4e9ff;
    box-sizing: border-box;
    padding: 13px 26px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
`

export const Row = styled.div`
    border: 1px solid #e4e9ff;
    padding: 10px 26px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
`

export const A = styled.a`
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #7a8ef2;
    cursor: pointer;
`

export const PopupCard = styled(Popover)`
    background: white;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    position: absolute;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;

    & div.arrow {
        display: none;
    }
`

export const Input = styled.input`
    background: #f6f7fc;
    border-radius: 10px;
    outline: none;
    border: none;
    width: 100%;
    font-family: Avenir;
    font-style: normal;
    font-weight: normal;
    font-size: 14px;
    line-height: 19px;
    color: #007bff;
    padding: 8px 20px;
    &::placeholder {
        padding-left: 20px;
    }
`
