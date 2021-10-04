import React from 'react';
import Expander from '../../../components/common/Expander/Expander';
import renderer from 'react-test-renderer';
import { configure, shallow, mount } from 'enzyme';
import Adapter from 'enzyme-adapter-react-16';
import { findByTestAttr } from '../../../utils';
import { act } from 'react-dom/test-utils';

configure({adapter: new Adapter()});

const initialShallowRender = (props = {}) => {
	return shallow(<Expander {...props}/>);
};

const initialMountRender = (props = {}) => {
	return mount(<Expander {...props}/>);
};

const initialProps = {
};

describe('Expander component',  () => {
	let wrapper;
	let fullWrapper;

	beforeEach(() => {

		const props = {
			...initialProps
		};

		wrapper = initialShallowRender(props);
		fullWrapper = initialMountRender(props);
	});

	afterEach(() => {
		fullWrapper && fullWrapper.unmount();
	});

	it('should render Expander component', () => {
		expect(wrapper.exists()).toBe(true);
	});

	it('should match with a snapshot', () => {
		const component = renderer.create(<Expander />);
		let tree = component.toJSON();
		expect(tree).toMatchSnapshot();
	});

	describe('Expander component with props', () => {
		let wrapper;
		let fullWrapper;
		const setState = jest.fn();
		const useStateSpy = jest.spyOn(React, 'useState');
		useStateSpy.mockImplementation((init) => [init, setState]);
		const actions = async (wrapper, _actions) => {
			await act(async () => {
				await (new Promise(resolve => setTimeout(resolve, 0)));
				_actions();
				wrapper.update();
			});
		};

		beforeEach(() => {
			const props = {
				...initialProps,
				expanded: true
			};

			wrapper = initialShallowRender(props);
			fullWrapper = initialMountRender(props);
		});

		afterEach(() => {
			fullWrapper && fullWrapper.unmount();
		});

		it('should render correct defaultActiveKey prop', () => {
			const component = findByTestAttr(wrapper, 'accordion-item');
			expect(component.prop('defaultActiveKey')).toBe('0');
		});
		it('should call onClick handler', async () => {
			const component = findByTestAttr(fullWrapper, 'expander-button').at(0);
			await actions(component, () => {
				component.props().onClick();
			});
			expect(setState).toHaveBeenCalledTimes(1);
		});
	});
});
