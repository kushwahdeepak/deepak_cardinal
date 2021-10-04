import React, { useMemo, useRef } from 'react'
import Pagination from 'react-bootstrap/Pagination'

import './styles/Paginator.scss'

function Paginator(props) {
    const inputRef = useRef()
    const {
        pageCount,
        pageWindowSize,
        activePage,
        setActivePage,
        showGoToField = true,
    } = props
    const lastPageIndex = pageCount - 1

    const handleChange = (evt) => {
        const notAllowedKeysCode = [46, 43, 69, 101, 45]
        const code = evt.which || evt.keyCode

        if (notAllowedKeysCode.includes(code)) {
            evt.preventDefault()
        }

        if (evt.key === 'Enter') {
            try {
                goToPage(evt.target.value)
            } catch (error) {
                console.log(error)
            }
        }
    }

    const goToPage = (page) => {
        const parsedNumber = Number(page) - 1
        if (parsedNumber < 0 || parsedNumber > lastPageIndex) return
        setActivePage(parsedNumber)
        if (inputRef.current) inputRef.current.value = ''
    }

    const visiblePaginationItems = useMemo(() => {
        const { rangeStart, rangeEnd } = calcVisibleItemRange(
            pageWindowSize,
            pageCount,
            activePage
        )

        const prevPageIndex = Math.max(activePage - 1, 0)
        const nextPageIndex = Math.min(activePage + 1, lastPageIndex)

        const items = []

        items.push(
            <Pagination.First
                key="prev5"
                className="prev"
                onClick={() =>
                    setActivePage(Math.max(activePage - pageWindowSize, 0))
                }
            />
        )

        items.push(
            <Pagination.Prev
                key="prev"
                className="prev"
                onClick={() => setActivePage(prevPageIndex)}
            />
        )

        items.push(
            <Pagination.Item
                key="first"
                data-test="first-page-btn"
                active={activePage === 0}
                onClick={() => setActivePage(0)}
            >
                1
            </Pagination.Item>
        )

        if (rangeStart >= 2)
            items.push(<Pagination.Ellipsis key={'start-ellipsis'} />)

        for (let i = rangeStart; i <= rangeEnd; i++) {
            if (i === lastPageIndex || i === 0) continue
            items.push(
                <Pagination.Item
                    key={i}
                    active={i === activePage}
                    onClick={() => setActivePage(i)}
                >
                    {i + 1}
                </Pagination.Item>
            )
        }

        if (rangeEnd + 1 < pageCount - 1)
            items.push(<Pagination.Ellipsis key={'end-ellipsis'} />)

        items.push(
            <Pagination.Item
                key="last"
                data-test="last-page-btn"
                active={lastPageIndex === activePage}
                onClick={(event) => setActivePage(lastPageIndex)}
            >
                {lastPageIndex + 1}
            </Pagination.Item>
        )

        items.push(
            <input
                key="to_page"
                type="number"
                min="0"
                placeholder="To page: "
                ref={inputRef}
                onKeyPress={(evt) => handleChange(evt)}
                className="paginator-input"
            />
        )

        items.push(
            <Pagination.Next
                key="next"
                onClick={() => setActivePage(nextPageIndex)}
            />
        )

        items.push(
            <Pagination.Last
                key="next5"
                onClick={() =>
                    setActivePage(
                        Math.min(activePage + pageWindowSize, lastPageIndex)
                    )
                }
            />
        )

        return items
    }, [pageCount, activePage])

    return pageCount && pageCount > 1 ? (
        <Pagination data-test="pagination">{visiblePaginationItems}</Pagination>
    ) : null
}

function calcVisibleItemRange(windowSize, pageCount, activePage) {
    const lastPageIndex = pageCount - 1
    const rangeWidth = Math.min(windowSize, pageCount)
    let rangeStart = Math.max(activePage - Math.floor(rangeWidth / 2), 0)
    const rangeEnd = Math.min(rangeStart + rangeWidth - 1, lastPageIndex)
    const rangeEndOverextension = Math.max(
        rangeStart + rangeWidth - 1 - lastPageIndex,
        0
    )
    rangeStart -= rangeEndOverextension

    return { rangeStart, rangeEnd }
}

export default Paginator
