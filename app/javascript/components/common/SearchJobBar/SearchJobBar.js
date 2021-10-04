import React from 'react'
import Image from 'react-bootstrap/Image'
import SearchIcon from '../../../../assets/images/icons/search.svg'
import './styles/SearchJobBar.scss'

const SearchJobBar = (props) => {
    const { submitJobSearch, handleInputChange, inputValue } = props

    return (
        <div className="job-search-bar-container">
            <div className="job-search-bar-wrapper">
                <form className="job-search-form">
                    <div className="job-search-form__row">
                        <div className="job-search-form__input-block">
                            <Image
                                src={SearchIcon}
                                className="job-search-icon"
                            />
                            <input
                                onChange={(event) =>
                                    handleInputChange(event.target.value)
                                }
                                className="job-search-form__input"
                                type="text"
                                value={inputValue}
                                placeholder="Search by Job title, keyword, or company"
                            />
                        </div>
                        <button
                            className="job-search-form__submit-btn"
                            onClick={(event) => {
                                event.preventDefault()
                                submitJobSearch(event)
                            }}
                        >
                            <span>Search</span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    )
}

export default SearchJobBar
