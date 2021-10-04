import React from 'react'
import Card from 'react-bootstrap/Card'
import Button from 'react-bootstrap/Button'
import styles from './styles/FilterGroup.module.scss'
import './styles/FilterGroup.scss'


function FilterGroup({ children, filterCount, experienceYearsCount, candidatePage }) {

    const filtersActive = filterCount > 0

    const experienceYears = experienceYearsCount ? true : ''

    return (

        <Card className={`${styles.filtersPanel + ' shadow-sm'} ${candidatePage ? 'candidate-card' : 'filters-card'}`}>
            <h2 className="filters-title">Filter Your Search:</h2>
            <Card.Body className="p-0">{children}</Card.Body>
        </Card>
    )
}

export default FilterGroup
