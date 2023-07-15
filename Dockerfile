FROM node:18.12.0

# Install necessary dependencies
RUN apt-get update \
    && apt-get install -y curl wget git zsh

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install ohmyzsh and powerlevel10k
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

# Set zsh as the default shell
RUN sed -i 's|exec "$SHELL" -l|exec /bin/zsh -l|' /usr/bin/code-server

# Install zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Install zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/plugins/zsh-autosuggestions

# Copy custom .p10k.zsh
COPY .p10k.zsh /root/.p10k.zsh

# Copy custom .zshrc
COPY .zshrc /root/.zshrc

# Copy custom fonts
COPY fonts /root/.local/share/fonts

# Install gitemoji-cli
RUN npm i -g gitmoji-cli

# Set the workspace directory as the root
WORKDIR /home/root/workspace

# Expose the code-server port
EXPOSE 8080
# Expose others ports
EXPOSE 3000
EXPOSE 3001

# Start the code-server with workspace as workdir
CMD ["code-server", "--host", "0.0.0.0", "--auth", "none"]
