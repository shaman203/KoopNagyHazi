package nagyHazi;


import jason.architecture.AgArch;
import jason.asSemantics.ActionExec;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.Term;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.List;

import javax.swing.GroupLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextArea;


public class GUI extends AgArch {

	JTextArea jt;
	JFrame    f;
	JButton createConnectionBtn;
	JButton dropConnectionBtn;
	JComboBox<String> fromBox;
	JComboBox<String> toBox;

	List<String> agentList;

	public GUI() {

		fromBox = new JComboBox<String>();
		toBox = new JComboBox<String>();

		createConnectionBtn = new JButton("Add connection");
		createConnectionBtn.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				Literal goal = ASSyntax.createLiteral("create_connection");
				goal.addTerms(ASSyntax.createString("router1"));
				goal.addTerms(ASSyntax.createString("router2"));
				goal.addTerms(ASSyntax.createNumber(5));
				getTS().getC().addAchvGoal(goal, null);


			}
		});

		dropConnectionBtn = new JButton("Drop connection");
		dropConnectionBtn.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				Literal goal = ASSyntax.createLiteral("drop_connection");
				goal.addTerms(ASSyntax.createString("router1"));
				goal.addTerms(ASSyntax.createString("router3"));
				goal.addTerms(ASSyntax.createNumber(5));
				getTS().getC().addAchvGoal(goal, null);

			}
		});

		JPanel mainPanel = new JPanel();
		GroupLayout layout = new GroupLayout(mainPanel);
		mainPanel.setLayout(layout);

		layout.setHorizontalGroup(
				layout.createSequentialGroup()
				.addComponent(fromBox)
				.addComponent(toBox)
				.addGroup(layout.createParallelGroup(GroupLayout.Alignment.LEADING)
						.addComponent(createConnectionBtn)
						.addComponent(dropConnectionBtn))
				);
		layout.setVerticalGroup(
				layout.createSequentialGroup()
				.addGroup(layout.createParallelGroup(GroupLayout.Alignment.BASELINE)
						.addComponent(fromBox)
						.addComponent(toBox))
						.addComponent(createConnectionBtn)
						.addComponent(dropConnectionBtn)
				);

		f = new JFrame("Simulator");
		f.getContentPane().add(mainPanel);
		f.pack();
		f.setVisible(true);
	}

	@Override
	public void act(ActionExec action, List<ActionExec> feedback) {
		if (action.getActionTerm().getFunctor().startsWith("tell_agents")) {
			this.agentList = new ArrayList<String>();
			for(Term term :action.getActionTerm().getTerms())
			{
				agentList.add(term.toString());
			}
			action.setResult(true);
			feedback.add(action);

		} else {
			super.act(action,feedback); // send the action to the environment to be performed.
		}
	}


	private void addEdge(String node1, String node2, int cost)
	{

	}

	private void removeEdge(String node1, String node2)
	{

	}

	@Override
	public void stop() {
		f.dispose();
		super.stop();
	}
}
