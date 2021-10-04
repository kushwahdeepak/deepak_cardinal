import React, {
    useState,
    useCallback,
    useRef,
} from 'react'
import {
    Wrapper,
    Row,
    Container,
    Button,
    W4text,
    W8text,
    ScrollContainer,
} from './styles/CandidateViewProfile.styled'
import CloseButton from '../../common/Styled components/CloseButton'
import ReactCrop from 'react-image-crop'
import 'react-image-crop/dist/ReactCrop.css'

function getCroppedImg(image, crop, fileName) {
    let fileBlob = null
    const canvas = document.createElement('canvas')
    const pixelRatio = window.devicePixelRatio
    const scaleX = image.naturalWidth / image.width
    const scaleY = image.naturalHeight / image.height
    const ctx = canvas.getContext('2d')

    canvas.width = crop.width * pixelRatio * scaleX
    canvas.height = crop.height * pixelRatio * scaleY

    ctx.setTransform(pixelRatio, 0, 0, pixelRatio, 0, 0)
    ctx.imageSmoothingQuality = 'high'

    ctx.drawImage(
        image,
        crop.x * scaleX,
        crop.y * scaleY,
        crop.width * scaleX,
        crop.height * scaleY,
        0,
        0,
        crop.width * scaleX,
        crop.height * scaleY
    )

    return new Promise((resolve, reject) => {
        canvas.toBlob(
            (blob) => {
                if (!blob) {
                    //reject(new Error('Canvas is empty'));
                    console.error('Canvas is empty')
                    return
                }
                blob.name = fileName
                fileBlob = blob
                resolve(fileBlob)
            },
            'image/*',
            1
        )
    })
}

function CropImageModal(props) {
    const { setOpenInner, profile, saveCropImage } = props
    const [upImg, setUpImg] = useState()
    const imgRef = useRef(null)
    const [crop, setCrop] = useState({})

    const onLoad = useCallback((img) => {
        imgRef.current = img
        const aspect = 1 / 1
        const width =
            img.width / aspect < img.height * aspect
                ? 100
                : ((img.height * aspect) / img.width) * 100
        const height =
            img.width / aspect > img.height * aspect
                ? 100
                : (img.width / aspect / img.height) * 100
        const y = (100 - height) / 2
        const x = (100 - width) / 2

        setCrop({ unit: 'px', width, height, x, y, aspect })
        const initialCrop = { unit: 'px', width, height, x, y, aspect } 
        makeClientCrop(initialCrop)
        return false
    }, [])

    async function makeClientCrop(crop) {
        if (imgRef.current && crop.width && crop.height) {
            const croppedImageUrl = await getCroppedImg(
                imgRef.current,
                crop,
                'newFile.png'
            )
            setUpImg(croppedImageUrl)
        }
    }

    return (
        <Wrapper style={{ height: '75%' }}>
            <Container direction="column">
                <Row direction="row" jContent="space-between">
                    <W4text size="32px" color="#1D2447" style={{textAlign:'center'}}>
                        Resize image
                    </W4text>
                    <CloseButton handleClick={() => setOpenInner(!open)} />
                </Row>

                <ScrollContainer>
                    <Row direction="row">
                        <Container direction="row">
                            <ReactCrop
                                src={profile}
                                onImageLoaded={onLoad}
                                crop={crop}
                                keepSelection
                                onChange = {(crop)=> setCrop(crop)}
                                onComplete={(crop) => makeClientCrop(crop)}
                            />
                        </Container>
                    </Row>
                </ScrollContainer>
                <Row
                    direction="row"
                    jContent="flex-end"
                    style={{ marginBottom: '0px' }}
                >
                    <Button
                        onClick={() => {
                         saveCropImage(upImg)
                        }}
                        lr="16px"
                        tb="5px"
                    >
                        <W8text size="14px" color="#ffff">
                            Save Changes
                        </W8text>
                    </Button>
                </Row>
            </Container>
        </Wrapper>
    )
}

export default CropImageModal
