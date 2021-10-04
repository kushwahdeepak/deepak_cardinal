import styled from 'styled-components'

export const Head = styled.div`
    display: flex;
    flex-direction: row;
    justify-content: space-between;
`
export const Icon = styled.div`
    margin-left: 0.5rem;

    > svg {
        transform: ${(props) =>
            props.direction ? `rotate(0deg)` : `rotate(-90deg)`};
    }
`