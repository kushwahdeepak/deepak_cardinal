import React, { useState, useEffect, useMemo } from 'react'
import feather from 'feather-icons'
import Dropdown from 'react-bootstrap/Dropdown'
import { makeRequest } from '../RequestAssist/RequestAssist'
import styles from './styles/AtMentionInput.module.scss'
import isNil from 'lodash.isnil'

const AtMentionInput = React.forwardRef(
    ({ show, onClose, onItemSelect, excludeList }, ref) => {
        const [orgMembers, setOrgMembers] = useState([])
        const [filterText, setFilterText] = useState('')

        useEffect(() => {
            ;(async () => {
                const url = '/get_users_in_organization'
                const result = await makeRequest(url, 'get', {})
                setOrgMembers(result.data.member)
            })()
        }, [])

        useEffect(() => feather.replace(), [show, filterText])

        const CustomToggle = useMemo(() => {
            return React.forwardRef(
                ({ children, onClick }, customToggleRef) => (
                    <div
                        style={{
                            position: 'relative',
                            display: show ? 'flex' : 'none',
                            alignItems: 'center',
                        }}
                    >
                        <input
                            className="input"
                            ref={customToggleRef}
                            type="text"
                            placeholder="org member"
                            style={{ paddingLeft: '1.2rem' }}
                            onClick={(e) => {
                                onClick(e)
                            }}
                            onFocus={(e) => onClick(e)}
                            onKeyDown={(e) => {
                                if (e.key === 'Escape') {
                                    e.preventDefault()
                                    e.stopPropagation()
                                    onClose()
                                }
                            }}
                            onChange={(e) => {
                                setFilterText(e.target.value)
                            }}
                            autoComplete="off"
                        ></input>
                        <i
                            data-feather="at-sign"
                            style={{
                                position: 'absolute',
                                left: '0.2rem',
                                width: '1rem',
                                height: '1rem',
                            }}
                        ></i>
                    </div>
                )
            )
        }, [show])
        const displayMenuItems = () => {
            const filteredMemebers = orgMembers.length > 0 ? orgMembers.filter(
                (member) =>
                    member.name
                        .toLowerCase()
                        .includes(filterText.toLowerCase()) &&
                    isNil(
                        excludeList.find(
                            (excludeMember) => excludeMember.id === member.id
                        )
                    )
            ) : []

            return filteredMemebers.length > 0 ? (
                filteredMemebers.map((member, index) => (
                    <Dropdown.Item
                        key={member.id}
                        eventKey={`${index}`}
                        onClick={() => onItemSelect(member)}
                        onSelect={() => onItemSelect(member)}
                    >
                        {member.name}
                    </Dropdown.Item>
                ))
            ) : (
                <Dropdown.Item onClick={(e) => e.stopPropagation()}>
                    No organization members found
                </Dropdown.Item>
            )
        }

        return (
            <>
                <Dropdown>
                    <Dropdown.Toggle
                        as={CustomToggle}
                        id="dropdown-custom-components"
                        ref={ref}
                    >
                        Custom toggle
                    </Dropdown.Toggle>

                    <Dropdown.Menu className={styles.menu}>
                        {displayMenuItems()}
                    </Dropdown.Menu>
                </Dropdown>
            </>
        )
    }
)

export default AtMentionInput
