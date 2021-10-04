import React, { useEffect } from 'react'
import styles from './styles/SearchBar.module.scss'
import Row from 'react-bootstrap/Row'
import Col from 'react-bootstrap/Col'
import FormControl from 'react-bootstrap/FormControl'
import Image from 'react-bootstrap/Image'
import Button from 'react-bootstrap/Button'
import SearchIcon from '../../../../assets/images/talent_page_assets/search-icon.png'

function SearchBar({
    placeholder,
    value,
    onChange,
    onEnterPressed,
    onButtonClick,
    candidateSource,
    candidatePage,
    hideButton=true,
}) {
    return (
      <Row className={`${candidatePage ? styles.candidateSearchBar: styles.atsSearchBar} ${styles.searchBarRow}`}>
        <Col>
          <FormControl
            id={candidatePage ? styles.candidateSearchSpace : ""}
            placeholder={placeholder}
            style={{ textIndent: '40px'}}
            className={candidatePage ? styles.candidateSearch : styles.placeholderText}
            value={value}
            onChange={onChange}
            onKeyPress={(e) => {
              if (e.key === 'Enter') {
                onEnterPressed(e)
              }
            }}
          />

          <div
            style={{
              position: 'absolute',
              left: '30px',
              top: '8px',
              zIndex: '2',
            }}
          >
            <Image src={SearchIcon} style={{filter: candidateSource=='lead_candidate_search' ?  'opacity(0.5)' : ''}} fluid />
          </div>
        </Col>
        { hideButton &&
        <Col xs="auto" className="pl-0">
          <Button className={styles.searchButton} onClick={onButtonClick}>
            Search
          </Button>
        </Col> }
      </Row>
    )
  }

export default SearchBar
