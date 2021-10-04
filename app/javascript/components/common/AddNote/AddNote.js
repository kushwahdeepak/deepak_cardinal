import React, { useState, useRef, useEffect } from 'react'
import Image from 'react-bootstrap/Image'
import axios from 'axios'

import styles from './styles/AddNote.module.scss'
import { makeRequest } from '../RequestAssist/RequestAssist'
import { MentionsInput, Mention } from 'react-mentions'
import PencilIcon from '../../../../assets/images/icons/pencil-icon-v2.svg'

function AddNote({ candidate, setNoteAdded }) {
    const [note, setNote] = useState('')
    const [expandNote, setExpandNote] = useState(false)
    const noteInputAreaRef = useRef()
    const [mentionedMembers, setMentionedMembers] = useState([])
    const [members, setMembers] = useState([])
    const [loading, setLoading] = useState(false)

    const addNote = () => {
        setLoading(true)
        var token = document.querySelector('meta[name="csrf-token"]').content
        axios
            .post(`/people/${candidate.id}/notes`, {
                authenticity_token: token,
                body: note,
                person_id: candidate.id,
                mention_ids: mentionedMembers.map((m) => m.id),
            })
            .then((res) => {
                setNoteAdded(true)
                setNote('')
                setExpandNote(false)
                setLoading(false)
            })
            .catch((err) => {
                console.log(err)
                setLoading(false)
            })
    }

    const getWrapperStyle = () => {
        return expandNote ? { height: 'max-content' } : { height: '30px' }
    }

    const expandInput = () => {
        setExpandNote(!expandNote)
    }

    useEffect(() => {
        if (noteInputAreaRef.current && expandNote)
            noteInputAreaRef.current.focus()
    }, [expandNote])

    const getOrganizationMembers = async () => {
        const url = '/get_users_in_organization'
        const result = await makeRequest(url, 'get', {})
        if (result?.data.member.length == 0) {
            setMembers([{ id: -1, display: 'No members to mention' }])
        } else {
            setMembers(
                result?.data.member.map((m) => ({
                    id: m.id,
                    display: `${m.first_name + ' ' + m.last_name}`,
                    email: '',
                }))
            )
        }
    }

    const onAdd = (id) => {
        if (id == -1) return
        setMentionedMembers([
            ...mentionedMembers,
            members.find((m) => m.id === id),
        ])
    }

    const removeMention = () => {
        setMentionedMembers(
            mentionedMembers.filter((m) => note.includes(`@[${m.display}]`))
        )
    }

    useEffect(() => {
        removeMention()
    }, [note])

    useEffect(() => {
        getOrganizationMembers()
    }, [])

    const defaultStyle = {
        control: {
            fontSize: 12,
        },

        highlighter: {
            overflow: 'hidden',
        },

        input: {
            margin: 0,
        },

        '&singleLine': {
            control: {
                display: 'inline-block',
                width: 130,
            },

            highlighter: {
                padding: 1,
                border: '2px inset transparent',
            },

            input: {
                padding: 10,
                border: '2px inset',
            },
        },

        '&multiLine': {
            control: {
                fontFamily: 'inherit',
            },

            highlighter: {
                padding: 9,
            },

            input: {
                padding: 9,
                minHeight: 20,
                outline: 0,
                border: 0,
            },
        },

        suggestions: {
            list: {
                backgroundColor: 'white',
                border: '1px solid rgba(0,0,0,0.15)',
                fontSize: 10,
            },

            item: {
                borderBottom: '1px solid rgba(0,0,0,0.15)',

                '&focused': {
                    backgroundColor: '#cee4e5',
                },
            },
        },
    }

    const defaultMentionStyle = {
        backgroundColor: '#cee4e5',
    }

    return (
        <>
            {expandNote && (
                <div
                    className={styles.backdrop}
                    onClick={() => setExpandNote(false)}
                ></div>
            )}
            <div className={styles.addNotesTextarea} style={getWrapperStyle()}>
                <div
                    className="position-relative"
                    style={{
                        height: '100%',
                        maxHeight: '30px',
                        background: '#4c68ff',
                    }}
                >
                    <Image
                        src={PencilIcon}
                        style={{
                            position: 'absolute',
                            height: '10px',
                            width: '10px',
                            bottom: '8px',
                            left: '10px',
                        }}
                    />
                    <input
                        placeholder="Add Notes"
                        type="text"
                        onClick={expandInput}
                    />
                </div>
                <div
                    style={{
                        display: expandNote ? 'flex' : 'none',
                        flexDirection: 'column',
                        paddingLeft: '7px',
                        paddingRight: '7px',
                    }}
                >
                    <input
                        type="text"
                        disabled
                        placeholder="@ mention to share with a coworker (optional)"
                        className={styles.mentionInput}
                    />

                    <MentionsInput
                        inputRef={noteInputAreaRef}
                        value={note}
                        onChange={(e) => setNote(e.target.value)}
                        style={defaultStyle}
                    >
                        <Mention
                            trigger="@"
                            data={members}
                            markup="@[__display__]"
                            displayTransform={(id, display) => '@' + display}
                            renderSuggestion={(
                                suggestion,
                                search,
                                highlightedDisplay,
                                index,
                                focused
                            ) => {
                                const [firstName, lastName] = suggestion.display
                                    ? suggestion.display.split(' ')
                                    : ['', '']
                                return (
                                    <div
                                        className={styles.memberRow}
                                        onClick={
                                            suggestion.id == -1
                                                ? (e) => {
                                                      e.stopPropagation()
                                                      e.preventDefault()
                                                  }
                                                : () => {}
                                        }
                                    >
                                        {suggestion.id == -1 ? (
                                            <p>No members to display</p>
                                        ) : (
                                            <>
                                                <div className={styles.logo}>
                                                    {firstName
                                                        ? firstName
                                                              .charAt(0)
                                                              .toUpperCase()
                                                        : ''}
                                                    {lastName
                                                        ? lastName
                                                              .charAt(0)
                                                              .toUpperCase()
                                                        : ''}
                                                </div>
                                                <div
                                                    style={{
                                                        marginLeft: '15px',
                                                    }}
                                                >
                                                    <p className={styles.text}>
                                                        @{firstName}
                                                    </p>
                                                    <p className={styles.text}>
                                                        {highlightedDisplay}
                                                    </p>
                                                </div>
                                            </>
                                        )}
                                    </div>
                                )
                            }}
                            onAdd={onAdd}
                            style={defaultMentionStyle}
                        />
                    </MentionsInput>

                    <button
                        className={styles.doneButton}
                        onClick={addNote}
                        disabled={loading}
                    >
                        {loading ? 'Submitting...' : 'Done'}
                    </button>
                </div>
            </div>
        </>
    )
}

export default AddNote
