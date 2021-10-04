import React, { useState } from 'react'
import { Accordion } from 'react-bootstrap'
import Card from 'react-bootstrap/Card'
import Button from 'react-bootstrap/Button'
import { useAccordionToggle } from 'react-bootstrap/AccordionToggle'

import './style/expander.scss'
import { Head, Icon } from './style/Expander.styled'

function Expander({ label, expanded, children, candidatePage }) {
    return (
        <Accordion
        className="text-font"
            data-test="accordion-item"
            defaultActiveKey={expanded ? '0' : '-1'}
            style={{width: "210px"}}
        >
            <Card style={{ border: 'none' }}>
                <CustomToggle eventKey="0" candidatePage={candidatePage}>{label}</CustomToggle>
                <Accordion.Collapse eventKey="0">
                    <Card.Body style={{padding:'0px 1.25rem '}}>
                        {children}
                    </Card.Body>
                </Accordion.Collapse>
            </Card>
        </Accordion>
    )
}

function CustomToggle({ children, eventKey, candidatePage }) {
    const [expanded, setExpanded] = useState(true)

    const decoratedOnClick = useAccordionToggle(eventKey, () => {
        setExpanded((expanded) => !expanded)
    })

    return (
        <Button
            type="Button"
            variant="expander"
            style={{
                border: 'none',
                fontWeight: 500,
                backgroundColor: candidatePage ? 'white' : '',
            }}
            className= {candidatePage && expanded ?
                'candidate-class' : candidatePage && !expanded ?
                 'candidate-class expended-color-active' : ''}
            onClick={decoratedOnClick}
            data-test="expander-button"
        >
            <Head>
                <label style={{ fontSize: '13px' }}>{children}</label>
                <Icon direction={expanded ? 1 : 0}>
                    <i data-feather="chevron-down" />
                </Icon>
            </Head>
        </Button>
    )
}

export default Expander
