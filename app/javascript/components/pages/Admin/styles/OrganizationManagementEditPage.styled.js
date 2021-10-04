import styled from 'styled-components'
import BButton from 'react-bootstrap/Button'

export const Logo = styled.div`
    background: ${(props) =>
        props.image
            ? `url(${props.image}) no-repeat center center`
            : `linear-gradient(
        133.96deg,
        #ced9ff -13.41%,
        #eeeefd 51.28%,
        #ccceff 114.63%
    )`};
    background-size:100% 100%;
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 20px;
    line-height: 27px;
    text-align: center;
    color: #9fabe8;
    padding: 35px 30px;
    height: 150px;
    width: 150px;
`
export const Member = styled.div`
    background: ${(props) =>
        props.image
            ? `url(${props.image}) no-repeat center center`
            : `linear-gradient(
        133.96deg,
        #ced9ff -13.41%,
        #eeeefd 51.28%,
        #ccceff 114.63%
    )`};
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    border-radius: 10px;
    color: #3d5484;
    padding: 5px 0px 5px 10px;
    margin-bottom:25px;
`

export const Button = styled(BButton)`
    background: ${(props) =>
        props.background
            ? props.background
            : `linear-gradient(
        94.67deg,
        #5f78ff -1.19%,
        #7185f2 53.94%,
        #8d91ff 102.59%
    )`};
    border-radius: 20px;
    padding: 9px 31px;
    font-weight: 800;
    font-size: 16px;
    line-height: 22px;
    text-align: center;
    color: #ffffff;
`

export const RemoveButton = styled(BButton)`
    background: ${(props) =>
        props.background
            ? props.background
            : `linear-gradient(
        94.67deg,
        #5f78ff -1.19%,
        #7185f2 53.94%,
        #8d91ff 102.59%
    )`};
    border-radius: 10px;
    padding: 4px 20px;
    font-weight: 800;
    font-size: 16px;
    line-height: 22px;
    text-align: center;
    color: #ffffff;
    float: right;
    margin-right: 5px;
`
export const MemberButton = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100%;
`