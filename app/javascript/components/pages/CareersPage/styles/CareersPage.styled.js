import styled from 'styled-components'

export const JoinUsSection = styled.div`
    background: linear-gradient(
        105.72deg,
        #eaf0ff -6.67%,
        #f0f2ff 52.25%,
        #deddff 103.38%
    );
    display: flex;
    @media (max-width: 1200px) {
        flex-direction: column;
    }
`

export const JoinUsText = styled.div`
    display: flex;
    flex-direction: column;
    justify-content: center;
    flex-grow: 1;
    padding-left: 96px;
`

export const H1 = styled.h1`
    font-family: inherit;
    font-style: normal;
    font-weight: ${(props) => props.weight || 800};
    font-size: ${(props) => props.size || '60px'};
    line-height: ${(props) => props.height || '82px'};
    color: #1d2447;
    margin-bottom: 0;
`

export const P = styled.p`
    font-family: inherit;
    font-style: normal;
    font-weight: ${(props) => props.weight || 'normal'};
    font-size: ${(props) => props.size || '24px'};
    line-height: ${(props) => props.height || '33px'};
    color: #1d2447;
    max-width: ${(props) => props.maxWidth || '400px'};
    margin-top: ${(props) => props.marginTop || 0};
    margin-bottom: 0;
`

export const CurrentOpeningsSection = styled.div`
    padding: 65px 120px;
    background: #f9faff;
`

export const Line = styled.div`
    border: ${(props) => props.borderColor || '1px solid #bfc5e2'};
    width: 100%;
    margin-top: ${(props) => props.marginTop || 0};
`

export const Openings = styled.div`
    display: flex;
    flex-wrap: wrap;
    margin-top: 66px;
`

export const Card = styled.div`
    width: calc(33.3% - 150px);
    margin: 30px 150px 0px 0px;
    display: flex;
    flex-direction: column;

    & h1 {
        text-transform: capitalize;
    }
`

export const Button = styled.button`
    padding: 10px 40px;
    font-weight: 500;
    font-size: 20px;
    line-height: 27px;
    color: #ffffff;
    background: linear-gradient(
        94.67deg,
        #4c68ff -1.19%,
        #6077f4 53.94%,
        #8185ff 102.59%
    );
    border-radius: 50px;
    margin-top: 25px;
    font-family: inherit;
`

export const LookingForWorkSection = styled.div`
    background: linear-gradient(
        105.72deg,
        #e9efff -6.67%,
        #e8eaff 52.25%,
        #e2e1ff 103.38%
    );
    display: flex;
    flex-direction: column;
    padding: 62px 0px;
    align-items: center;
`
